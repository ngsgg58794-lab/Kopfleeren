import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../services/categorizer.dart';
import '../services/storage_service.dart';
import '../services/locale_controller.dart';
import '../services/speech_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  final LocaleController localeController;
  const HomeScreen({super.key, required this.localeController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  final _speech = SpeechService();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  List<Task> _tasks = [];
  bool _doneCollapsed = true;
  bool _listening = false;
  String _baseText = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await _storage.load();
    setState(() => _tasks = tasks);
  }

  Future<void> _save() => _storage.save(_tasks);

  void _addTasksFromText(String text) {
    final lines =
        text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty);
    if (lines.isEmpty) return;
    setState(() {
      for (final line in lines) {
        _tasks.add(Task(
          id: DateTime.now().microsecondsSinceEpoch.toString() +
              line.hashCode.toString(),
          text: line,
          category: categorize(line),
        ));
      }
    });
    _save();
  }

  void _toggleDone(Task t) {
    setState(() => t.done = !t.done);
    _save();
  }

  void _delete(Task t) {
    setState(() => _tasks.removeWhere((x) => x.id == t.id));
    _save();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      setState(() {
        _listening = false;
        _controller.text = _controller.text.trim();
      });
      return;
    }

    _baseText = _controller.text.trim();
    if (_baseText.isNotEmpty) _baseText += '\n';

    setState(() => _listening = true);

    final ok = await _speech.start(
        localeId: switch (Localizations.localeOf(context).languageCode) {
          'de' => 'de_DE',
          _ => 'en_US',
        },
        onDone: () {
          if (!mounted) return;
          setState(() {
            _listening = false;
            _controller.text = _controller.text.trim();
          });
        },
        onResult: (text, isFinal) {
          if (isFinal) {
            _baseText += text.isEmpty ? '' : '$text\n';
            _controller.text = _baseText;
          } else {
            _controller.text = _baseText + text;
          }
          _controller.selection =
              TextSelection.collapsed(offset: _controller.text.length);
          if (!mounted) return;
          setState(() {});
        });

    if (!ok && mounted) {
      setState(() => _listening = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).speechUnavailable),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final open = _tasks.where((t) => !t.done).toList();
    final done = _tasks.where((t) => t.done).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.appTitle,
                        style: theme.textTheme.headlineMedium),
                  ),
                  IconButton(
                    tooltip: l10n.language,
                    icon:
                        Icon(Icons.translate, color: theme.colorScheme.outline),
                    onPressed: _showLanguagePicker,
                  ),
                ],
              ),
              Text(
                l10n.tagline,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.intro,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 20),
              _buildCapture(theme),
              const SizedBox(height: 28),
              if (_tasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    l10n.emptyState,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              ...categories
                  .where((c) => open.any((t) => t.category == c.id))
                  .map(
                    (c) => _buildGroup(
                      theme,
                      labelFor(l10n, c.id),
                      open.where((t) => t.category == c.id).toList(),
                    ),
                  ),
              if (open.isEmpty && done.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    l10n.allDone,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              if (done.isNotEmpty) _buildDoneSection(theme, done),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapture(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            minLines: 3,
            maxLines: 6,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.captureHint,
              hintStyle: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Semantics(
                button: true,
                label: l10n.micTooltip,
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _listening
                          ? theme.colorScheme.error
                          : Colors.transparent,
                      border: Border.all(
                        color: _listening
                            ? theme.colorScheme.error
                            : theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 18,
                      color: _listening
                          ? theme.colorScheme.onError
                          : theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _listening ? l10n.listening : '',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ),
              FilledButton(
                onPressed: () {
                  _addTasksFromText(_controller.text);
                  _controller.clear();
                  _focusNode.unfocus();
                },
                child: Text(l10n.addButton),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroup(ThemeData theme, String label, List<Task> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items.map((t) => TaskTile(
                task: t,
                onToggle: () => _toggleDone(t),
                onDelete: () => _delete(t),
              )),
        ],
      ),
    );
  }

  Widget _buildDoneSection(ThemeData theme, List<Task> done) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _doneCollapsed = !_doneCollapsed),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              _doneCollapsed
                  ? l10n.showDone(done.length)
                  : l10n.hideDone(done.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        if (!_doneCollapsed)
          ...done.map((t) => TaskTile(
                task: t,
                onToggle: () => _toggleDone(t),
                onDelete: () => _delete(t),
              )),
      ],
    );
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    final current = widget.localeController.locale?.languageCode;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(l10n.language,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final (code, label) in [
              (null, l10n.languageSystem),
              ('de', 'Deutsch'),
              ('en', 'English'),
            ])
              ListTile(
                title: Text(label),
                trailing: current == code
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  widget.localeController
                      .set(code == null ? null : Locale(code));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
