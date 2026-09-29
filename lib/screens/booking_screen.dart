import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class BookingScreen extends StatefulWidget {
  final Service? preselectedService;
  final bool isTeamBooking;
  final List<Worker> workers;
  final List<Team> teams;
  final List<Service> services;
  final Function(Map<String, dynamic>) onBook;

  const BookingScreen({
    super.key,
    this.preselectedService,
    this.isTeamBooking = false,
    required this.workers,
    required this.teams,
    this.services = const [],
    required this.onBook,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late bool _isTeam;
  int _currentStep = 0;
  Service? _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  double _duration = 3;
  int _workersNeeded = 3;
  String _matchMode = 'auto';
  Worker? _selectedWorker;
  Team? _selectedTeam;
  String _address = 'Kasarani, Nairobi';
  final _notesController = TextEditingController();
  String? _attireRequirement;
  bool _backupWorker = false;

  @override
  void initState() {
    super.initState();
    _isTeam = widget.isTeamBooking;
    _selectedService = widget.preselectedService;
    if (_selectedService != null) {
      _duration = _selectedService!.estimatedHours;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _totalSteps => _isTeam ? 5 : 4;

  int _calculatePrice() {
    if (_selectedService == null) return 0;
    final base = _selectedService!.basePrice;
    if (_selectedService!.priceUnit == 'hour') {
      return (base * _duration * _workersNeeded).round();
    }
    return base * _workersNeeded;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _submitBooking();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitBooking() {
    final price = _calculatePrice();
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    final data = <String, dynamic>{
      'customer_name': 'Anthony',
      'customer_type': 'household',
      'service_id': _selectedService?.id,
      'service_name': _selectedService?.name ?? 'House Cleaning',
      'booking_type': _isTeam ? 'team' : 'individual',
      'status': 'pending',
      'address': _address,
      'scheduled_date': _selectedDate.toIso8601String().split('T')[0],
      'scheduled_time': timeStr,
      'duration_hours': _duration,
      'workers_required': _workersNeeded,
      'total_price': price,
      'progress': 0,
    };
    if (!_isTeam && _selectedWorker != null) {
      data['worker_id'] = _selectedWorker!.id;
      data['status'] = 'assigned';
    }
    if (_isTeam && _selectedTeam != null) {
      data['team_id'] = _selectedTeam!.id;
    }
    if (_attireRequirement != null) {
      data['special_requirements'] = {
        'attire': _attireRequirement,
        'backup_worker': _backupWorker,
        'notes': _notesController.text,
      };
    }
    widget.onBook(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        title: Text(_isTeam ? 'Book a Team' : 'Book a Cleaner'),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              children: List.generate(_totalSteps, (i) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                        right: i < _totalSteps - 1 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i <= _currentStep
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _buildStepContent(),
            ),
          ),
          // Bottom CTA
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep == _totalSteps - 1) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                          PriceTag(amount: _calculatePrice(), size: 22),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                  ],
                  Expanded(
                    flex: _currentStep == _totalSteps - 1 ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _nextStep : null,
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? 'Pay & Confirm'
                            : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedService != null;
      case 1:
        return true;
      case 2:
        return _address.isNotEmpty;
      case 3:
        return _isTeam ? true : (_matchMode == 'auto' || _selectedWorker != null);
      case 4:
        return true;
      default:
        return true;
    }
  }

  Widget _buildStepContent() {
    if (_isTeam) {
      switch (_currentStep) {
        case 0:
          return _buildServiceStep();
        case 1:
          return _buildDateTimeStep();
        case 2:
          return _buildTeamDetailsStep();
        case 3:
          return _buildRequirementsStep();
        case 4:
          return _buildReviewStep();
      }
    } else {
      switch (_currentStep) {
        case 0:
          return _buildServiceStep();
        case 1:
          return _buildDateTimeStep();
        case 2:
          return _buildAddressStep();
        case 3:
          return _buildWorkerSelectionStep();
      }
    }
    return const SizedBox();
  }

  Widget _buildServiceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose a service',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select what you need help with',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        ..._availableServices.map((s) => _ServiceOption(
              service: s,
              isSelected: _selectedService?.id == s.id,
              onTap: () => setState(() {
                _selectedService = s;
                _duration = s.estimatedHours;
              }),
            )),
      ],
    );
  }

  List<Service> get _availableServices => widget.services;

  Widget _buildDateTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'When do you need it?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pick a date and time',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Date picker
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Time picker
        GestureDetector(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
            );
            if (time != null) setState(() => _selectedTime = time);
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Duration: ${_duration.toStringAsFixed(0)} hours',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _duration,
          min: 1,
          max: 12,
          divisions: 11,
          activeColor: AppColors.primary,
          label: '${_duration.toStringAsFixed(0)}h',
          onChanged: (v) => setState(() => _duration = v),
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address & notes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Where should the worker go?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Enter your address',
            prefixIcon: Icon(Icons.place_outlined),
          ),
          controller: TextEditingController(text: _address),
          onChanged: (v) => _address = v,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Gate code, parking, pets, allergies...',
            prefixIcon: Icon(Icons.note_outlined),
          ),
          controller: _notesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildWorkerSelectionStep() {
    final availableWorkers =
        widget.workers.where((w) => w.isVerified && w.isAvailable).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your worker',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Auto-match or pick a favourite',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Match mode toggle
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _matchMode = 'auto';
                  _selectedWorker = null;
                }),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _matchMode == 'auto'
                        ? AppColors.primarySoft
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _matchMode == 'auto'
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: _matchMode == 'auto'
                              ? AppColors.primary
                              : AppColors.textSecondary),
                      const SizedBox(height: 4),
                      Text(
                        'Auto-match',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _matchMode == 'auto'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _matchMode = 'pick'),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _matchMode == 'pick'
                        ? AppColors.primarySoft
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _matchMode == 'pick'
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person_search,
                          color: _matchMode == 'pick'
                              ? AppColors.primary
                              : AppColors.textSecondary),
                      const SizedBox(height: 4),
                      Text(
                        'Pick worker',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _matchMode == 'pick'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_matchMode == 'pick') ...[
          const SizedBox(height: AppSpacing.xl),
          ...availableWorkers.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _WorkerPickOption(
                  worker: w,
                  isSelected: _selectedWorker?.id == w.id,
                  onTap: () => setState(() => _selectedWorker = w),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildTeamDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'How many workers do you need?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: _workersNeeded > 1
                  ? () => setState(() => _workersNeeded--)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: AppSpacing.xl),
            Text(
              '$_workersNeeded',
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: AppSpacing.xl),
            IconButton.filled(
              onPressed: _workersNeeded < 20
                  ? () => setState(() => _workersNeeded++)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Enter the job address',
            prefixIcon: Icon(Icons.place_outlined),
          ),
          controller: TextEditingController(text: _address),
          onChanged: (v) => _address = v,
        ),
      ],
    );
  }

  Widget _buildRequirementsStep() {
    final attireOptions = [
      {'label': 'Practical cleaning attire', 'value': 'practical'},
      {'label': 'Uniform provided', 'value': 'uniform'},
      {'label': 'Hospitality attire', 'value': 'hospitality'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special requirements',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tell workers what to expect',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        const Text(
          'Attire',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...attireOptions.map((o) {
          final isSelected = _attireRequirement == o['value'];
          return GestureDetector(
            onTap: () => setState(() => _attireRequirement = o['value'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(o['label']!, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          title: const Text('Backup worker (+1)'),
          subtitle: const Text(
              'Extra worker on standby for large events'),
          value: _backupWorker,
          onChanged: (v) => setState(() => _backupWorker = v),
          activeThumbColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Notes',
            hintText: 'Access instructions, arrival time, tasks...',
          ),
          controller: _notesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final price = _calculatePrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review & pay',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Confirm your booking details',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewRow(
                  label: 'Service', value: _selectedService?.name ?? '-'),
              _ReviewRow(
                  label: 'Date',
                  value:
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              _ReviewRow(
                  label: 'Time', value: _selectedTime.format(context)),
              _ReviewRow(
                  label: 'Duration',
                  value: '${_duration.toStringAsFixed(0)} hours'),
              if (_isTeam)
                _ReviewRow(
                    label: 'Workers', value: '$_workersNeeded'),
              _ReviewRow(label: 'Address', value: _address),
              const Divider(),
              _ReviewRow(
                  label: 'Service cost',
                  value: 'KSh ${price.toString()}'),
              const _ReviewRow(
                  label: 'Service fee', value: 'KSh 200'),
              const _ReviewRow(label: 'VAT', value: 'KSh 0'),
              const Divider(),
              _ReviewRow(
                label: 'Total',
                value: 'KSh ${(price + 200).toString()}',
                isBold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your payment is held safely until you approve the job',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceOption extends StatelessWidget {
  final Service service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceOption({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(service.icon,
                  color: isSelected ? Colors.white : AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service.description,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            PriceTag(
              amount: service.basePrice,
              unit: service.priceUnit == 'hour' ? '/hr' : null,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerPickOption extends StatelessWidget {
  final Worker worker;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkerPickOption({
    required this.worker,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            WorkerAvatar(
              initials: worker.initials,
              photoUrl: worker.photoUrl,
              size: 48,
              ringColor: AppColors.success,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(worker.fullName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  RatingStars(
                      rating: worker.ratingAvg,
                      reviewCount: worker.jobsCompleted),
                  const SizedBox(height: 4),
                  Text(
                    worker.languages.join(', '),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReviewRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
