import 'package:area_mobile/app/components/bottomsheet/service_sign_bottomsheet.dart';
import 'package:area_mobile/app/components/home/list_last_workflows.dart';
import 'package:area_mobile/backend/api/common/user_workflow.dart';
import 'package:area_mobile/backend/models/services_model.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastAreaWidget extends StatefulWidget implements PreferredSizeWidget {
  const LastAreaWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => LastAreaWidgetState();
}

class LastAreaWidgetState extends State<LastAreaWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Text("Derniers worflows",
                    style: areaTheme.textTitleWhiteBold),
              ),
              ListLastWorkflowWidget(),
              // SizedBox(
              //     child: ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: workflows.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         // mainAxisSize: MainAxisSize.max,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding:
              //                 const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              //             child: FilledButton(
              //               onPressed: () {},
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: AreaTheme().backgroundContainer,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(18),
              //                 ),
              //                 padding: EdgeInsets.zero,
              //               ),
              //               child: Container(
              //                 width: double.infinity,
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(10.0),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Row(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.center,
              //                             children: [
              //                               Container(
              //                                 width: 60,
              //                                 height: 50,
              //                                 decoration: BoxDecoration(
              //                                     color: Colors.transparent,
              //                                     border: Border.all(
              //                                         color:
              //                                             areaTheme.subSubGrey,
              //                                         width: 2),
              //                                     borderRadius:
              //                                         BorderRadius.circular(
              //                                             10)),
              //                                 child: Padding(
              //                                   padding:
              //                                       const EdgeInsets.all(10.0),
              //                                   child: Image(
              //                                     image: AssetImage(
              //                                         workflows[index]
              //                                             ['photo']),
              //                                     fit: BoxFit.contain,
              //                                   ),
              //                                 ),
              //                               ),
              //                               Padding(
              //                                 padding:
              //                                     const EdgeInsetsDirectional
              //                                         .fromSTEB(8, 0, 0, 0),
              //                                 child: Column(
              //                                   crossAxisAlignment:
              //                                       CrossAxisAlignment.start,
              //                                   children: [
              //                                     Text(
              //                                       "Aujourd'hui",
              //                                       style: areaTheme
              //                                           .textBoldGrey_14,
              //                                     ),
              //                                     Text(
              //                                       "Commit de Puyool",
              //                                       style: areaTheme
              //                                           .textBoldWhite_18,
              //                                     )
              //                                   ],
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           SizedBox(
              //                             height: 30,
              //                             child: FilledButton(
              //                               onPressed: () {},
              //                               style: ElevatedButton.styleFrom(
              //                                 backgroundColor:
              //                                     areaTheme.blackGrey,
              //                                 shape: RoundedRectangleBorder(
              //                                   borderRadius:
              //                                       BorderRadius.circular(100),
              //                                 ),
              //                                 padding: EdgeInsets.zero,
              //                               ),
              //                               child: Padding(
              //                                 padding:
              //                                     const EdgeInsetsDirectional
              //                                         .fromSTEB(10, 0, 10, 0),
              //                                 child: Row(
              //                                   mainAxisAlignment:
              //                                       MainAxisAlignment.center,
              //                                   crossAxisAlignment:
              //                                       CrossAxisAlignment.center,
              //                                   children: [
              //                                     Icon(
              //                                       CupertinoIcons
              //                                           .arrow_2_circlepath,
              //                                       color: areaTheme.subGrey,
              //                                       size: 14,
              //                                     ),
              //                                     SizedBox(
              //                                       width: 4,
              //                                     ),
              //                                     Text(
              //                                       "Action",
              //                                       style: areaTheme
              //                                           .textBoldGrey_14,
              //                                     )
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                       const SizedBox(
              //                         height: 12,
              //                       ),
              //                       Divider(
              //                         height: 1,
              //                         thickness: 1.5,
              //                         color: areaTheme.subSubGrey,
              //                       ),
              //                       const SizedBox(
              //                         height: 12,
              //                       ),
              //                       Text(
              //                         "Description",
              //                         style: areaTheme.textBoldGrey_14,
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     );
              //   },
              // ))
            ]));
  }
}
