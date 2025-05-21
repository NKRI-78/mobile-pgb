class BadgesOrderModel {
  int? waitingPaymentCount;
  int? waitingConfirmCount;
  int? onProcessCount;
  int? onDeliveryCount;
  int? onDeliveredCount;
  int? onFinishedOrderCount;
  int? needReviewCount;
  int? onCancelCount;

  BadgesOrderModel(
      {this.waitingPaymentCount,
      this.waitingConfirmCount,
      this.onProcessCount,
      this.onDeliveryCount,
      this.onDeliveredCount,
      this.onFinishedOrderCount,
      this.needReviewCount,
      this.onCancelCount});

  BadgesOrderModel.fromJson(Map<String, dynamic> json) {
    waitingPaymentCount = json['waitingPaymentCount'];
    waitingConfirmCount = json['waitingConfirmCount'];
    onProcessCount = json['onProcessCount'];
    onDeliveryCount = json['onDeliveryCount'];
    onDeliveredCount = json['onDeliveredCount'];
    onFinishedOrderCount = json['onFinishedOrderCount'];
    needReviewCount = json['needReviewCount'];
    onCancelCount = json['onCancelCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['waitingPaymentCount'] = waitingPaymentCount;
    data['waitingConfirmCount'] = waitingConfirmCount;
    data['onProcessCount'] = onProcessCount;
    data['onDeliveryCount'] = onDeliveryCount;
    data['onDeliveredCount'] = onDeliveredCount;
    data['onFinishedOrderCount'] = onFinishedOrderCount;
    data['needReviewCount'] = needReviewCount;
    data['onCancelCount'] = onCancelCount;
    return data;
  }
}
