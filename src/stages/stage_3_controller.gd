extends StageController

func start(moses_screen_notifier: VisibleOnScreenNotifier2D) -> void:
    super(moses_screen_notifier)
    %WeaponSpawner.start()

func stop() -> void:
    %WeaponSpawner.stop()
