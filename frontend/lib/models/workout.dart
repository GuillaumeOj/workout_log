class CreateMovement {
  CreateMovement({
    required this.name,
    required this.position,
    this.durationSeconds,
    this.repetition,
  });

  String name;
  int position;
  int? durationSeconds;
  int? repetition;

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "duration_seconds": durationSeconds,
        "repetition": repetition,
      };
}

class CreateRound {
  CreateRound({
    required this.position,
    this.durationSeconds,
    this.repetition,
    this.movements,
  });

  int position;
  int? durationSeconds;
  int? repetition;
  List<CreateMovement>? movements;

  Map<String, dynamic> toJson() => {
        "position": position,
        "duration_seconds": durationSeconds,
        "repetition": repetition,
        "movements": movements?.map((x) => x.toJson()).toList(),
      };
}

class CreateWorkout {
  CreateWorkout({
    required this.name,
    this.description,
    required this.workoutType,
    this.rounds,
  });

  String name;
  String? description;
  String workoutType;
  List<CreateRound>? rounds;

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "workoutType": workoutType,
      };
}
