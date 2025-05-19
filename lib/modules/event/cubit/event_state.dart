part of 'event_cubit.dart';

final class EventState extends Equatable {
  final List<EventModel>? events;
  final String errorMessage;
  final bool isLoading;

  const EventState({
    this.events,
    this.errorMessage = "",
    this.isLoading = false,
  });

  EventState copyWith({
    List<EventModel>? events,
    String? errorMessage,
    bool? isLoading,
  }) {
    return EventState(
      events: events ?? this.events,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        events,
        errorMessage,
        isLoading,
      ];
}
