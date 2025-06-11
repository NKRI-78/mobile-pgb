part of '../view/membernear_page.dart';

// ignore: unused_element
class _ListUser extends StatelessWidget {
  const _ListUser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberNearBloc, MemberNearState>(builder: (context, st) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.blackColor, width: 2)),
        width: double.infinity,
        height: 300.0,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // ignore: prefer_is_empty
            st.loading
                ? const CustomLoadingPage()
                : (st.memberNearData != null &&
                        st.memberNearData!.isEmpty)
                    ? EmptyLocation(msg: "Tidak ada member disekitar anda")
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.4 / 2.3,
                          mainAxisSpacing: 20.0,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: st.memberNearData?.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = st.memberNearData![index];
                          String resultText =
                              (data.distance.toString().length < 4)
                                  ? data.distance.toString()
                                  : data.distance.toString().substring(0, 4);
                          return InkWell(
                            onTap: () {
                              GeneralModal.showModalMemberNearDetail(
                                  context, data);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5.0,
                                  left: index == 0 ? 6.0 : 5.0,
                                  right: 5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            color: AppColors.secondaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        margin: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25),
                                              child: Text(
                                                data.profile?.fullname?.split(' ')[0] ??
                                                    "",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: fontSizeDefault,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                '$resultText KM',
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: fontSizeSmall,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 60,
                                        right: 0,
                                        left: 0,
                                        child: ImageAvatar(
                                          image: (data.profile?.avatarLink?.isEmpty ??
                                                  true)
                                              ? "https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-businessman-user-avatar-wearing-suit-with-red-tie-png-image_5809521.png"
                                              : data.profile?.avatarLink ?? "",
                                          radius: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
          ],
        ),
      );
    });
  }
}
