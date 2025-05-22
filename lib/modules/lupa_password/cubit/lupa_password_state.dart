class LupaPasswordState {
  final String email;
  final bool loading;

  LupaPasswordState({
    this.email = "",
    this.loading = false,
  });

  LupaPasswordState copyWith({
    String? email,
    bool? loading,
  }) {
    return LupaPasswordState(
      email: email ?? this.email,
      loading: loading ?? this.loading,
    );
  }
}
