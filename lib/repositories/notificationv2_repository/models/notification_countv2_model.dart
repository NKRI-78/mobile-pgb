class NotificationCountV2Model {
  int? unreadCount;

  NotificationCountV2Model({this.unreadCount});

  NotificationCountV2Model.fromJson(Map<String, dynamic> json) {
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unreadCount'] = unreadCount;
    return data;
  }
}
