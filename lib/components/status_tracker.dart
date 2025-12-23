

import 'package:flutter/material.dart';

/// Represents the logical flow of a complaint status.
enum ComplaintStatus {
  registered,
  filed,
  remainderSent,
  legalNoticeSent,
  escalated,
  refunded,
}

/// Simple DTO (Data Transfer Object) used by the tracker.
/// Using nullable fields to match the original temp.dart structure.
class TextDto {
  final String? title;
  final String? date;

  const TextDto(this.title, this.date);
}

class ComplaintTracker extends StatefulWidget {
  final ComplaintStatus? status;

  /// This variable is used to get list of order sub title and date to show present status of product.
  final List<TextDto>? complaintRegister;

  /// This variable is used to get list of shipped sub title and date to show present status of product.
  final List<TextDto>? formalComplaintFile;

  /// This variable is used to get list of outOfDelivery sub title and date to show present status of product.
  final List<TextDto>? remainderToCompany;

  /// This variable is used to get list of delivered sub title and date to show present status of product.
  final List<TextDto>? legalNoticeSend;

  final List<TextDto>? escalatedEmail;

  final List<TextDto>? refunded;

  /// This variable is used to change color of active animation border.
  final Color? activeColor;

  /// This variable is used to change color of inactive animation border.
  final Color? inActiveColor;

  /// This variable is used to change style of heading title text.
  final TextStyle? headingTitleStyle;

  /// This variable is used to change style of heading date text.
  final TextStyle? headingDateTextStyle;

  /// This variable is used to change style of sub title text.
  final TextStyle? subTitleTextStyle;

  /// This variable is used to change style of sub date text.
  final TextStyle? subDateTextStyle;

  const ComplaintTracker({
    super.key,
    required this.status,
    this.complaintRegister,
    this.formalComplaintFile,
    this.remainderToCompany,
    this.legalNoticeSend,
    this.escalatedEmail,
    this.refunded,
    this.activeColor,
    this.inActiveColor,
    this.headingTitleStyle,
    this.headingDateTextStyle,
    this.subTitleTextStyle,
    this.subDateTextStyle,
  });

  @override
  State<ComplaintTracker> createState() => _ComplaintTrackerState();
}

class _ComplaintTrackerState extends State<ComplaintTracker>
    with TickerProviderStateMixin {
  // --- Animation Controllers ---
  /// Controller for the line after "Complaint Register"
  AnimationController? controller1;

  /// Controller for the line after "Formal Complaint File"
  AnimationController? controller2;

  /// Controller for the line after "Remainder to Company"
  AnimationController? controller3;
  // Note: "Legal Notice Send" has no line in this UI
  /// Controller for the line after "Escalated Email"
  AnimationController? controller4;

  /// Controller for the line after "Refunded / Closed"
  AnimationController? controller5;

  // --- Static values for completed steps ---
  /// Static value for the "Complaint Register" line (if completed)
  double controller1Value = 0.0;

  /// Static value for the "Formal Complaint File" line (if completed)
  double controller2Value = 0.0;

  /// Static value for the "Remainder to Company" line (if completed)
  double controller3Value = 0.0;

  /// Static value for the "Escalated Email" line (if completed)
  double controller4Value = 0.0;

  /// Static value for the "Refunded / Closed" line (if completed)
  double controller5Value = 0.0;

  /// Helper to get the integer index of the current status
  int _statusIndex(ComplaintStatus? s) {
    if (s == null) return -1;
    switch (s) {
      case ComplaintStatus.registered:
        return 0;
      case ComplaintStatus.filed:
        return 1;
      case ComplaintStatus.remainderSent:
        return 2;
      case ComplaintStatus.legalNoticeSent:
        return 3;
      case ComplaintStatus.escalated:
        return 4;
      case ComplaintStatus.refunded:
        return 5;
    }
  }

  @override
  void initState() {
    super.initState();
    int currentIndex = _statusIndex(widget.status);
    const duration = Duration(seconds: 2);

    // This logic sets completed steps to 1.0 (full)
    // and makes the *current* step's line animate.

    // Stage 0: Registered (Animating line: controller1)
    if (currentIndex == 0) {
      controller1 = AnimationController(vsync: this, duration: duration)
        ..repeat();
    }

    // Stage 1: Filed (Animating line: controller2)
    if (currentIndex >= 1) controller1Value = 1.0;
    if (currentIndex == 1) {
      controller2 = AnimationController(vsync: this, duration: duration)
        ..repeat();
    }

    // Stage 2: Remainder (Animating line: controller3)
    if (currentIndex >= 2) controller2Value = 1.0;
    if (currentIndex == 2) {
      controller3 = AnimationController(vsync: this, duration: duration)
        ..repeat();
    }

    // Stage 3: Legal (Animating line: controller4)
    if (currentIndex >= 3) controller3Value = 1.0;
    if (currentIndex == 3) {
      controller4 = AnimationController(vsync: this, duration: duration)
        ..repeat();
    }

    // Stage 4: Escalated (Animating line: controller5)
    if (currentIndex >= 4) controller4Value = 1.0;
    if (currentIndex == 4) {
      controller5 = AnimationController(vsync: this, duration: duration)
        ..repeat();
    }

    // Stage 5: Refunded (No animating line)
    if (currentIndex >= 5) controller5Value = 1.0;
    // No controller animates here, all are complete.

    // Add a listener to all active controllers to rebuild the widget on each tick
    void listener() => setState(() {});
    controller1?.addListener(listener);
    controller2?.addListener(listener);
    controller3?.addListener(listener);
    controller4?.addListener(listener);
    controller5?.addListener(listener);
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    controller1?.dispose();
    controller2?.dispose();
    controller3?.dispose();
    controller4?.dispose();
    controller5?.dispose();
    super.dispose();
  }

  /// Helper to build the sub-item list for each stage
  Widget _buildSubList(List<TextDto>? items) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              items?[index].title ?? "",
              style: widget.subTitleTextStyle ?? const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              items?[index].date ?? "",
              style:
                  widget.subDateTextStyle ??
                  TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8); // Increased spacing
      },
      itemCount: items != null && items.isNotEmpty ? items.length : 0,
    );
  }

  /// Helper to calculate the height for the connecting line
  double _calculateLineHeight(List<TextDto>? items) {
    int count = items != null && items.isNotEmpty ? items.length : 0;
    if (count == 0) return 60.0;
    // Base height + (height per item)
    return 60.0 + (count - 1) * 44.0;
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _statusIndex(widget.status);
    final Color activeCol = widget.activeColor ?? Colors.green;
    final Color inactiveCol = widget.inActiveColor ?? Colors.grey.shade300;

    return Column(
      children: [
        // --- Stage 0: Complaint Registered ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: activeCol, // First step is always active
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Complaint Registered ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 2,
                    height: _calculateLineHeight(widget.complaintRegister),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: LinearProgressIndicator(
                        value: controller1?.value ?? controller1Value,
                        backgroundColor: inactiveCol,
                        color: activeCol,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(child: _buildSubList(widget.complaintRegister)),
              ],
            ),
          ],
        ),

        // --- Stage 1: Formal Complaint File ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: currentIndex >= 1 ? activeCol : inactiveCol,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Formal Complaint File ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 2,
                    height: _calculateLineHeight(widget.formalComplaintFile),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: LinearProgressIndicator(
                        value: controller2?.value ?? controller2Value,
                        backgroundColor: inactiveCol,
                        color: currentIndex >= 1 ? activeCol : inactiveCol,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(child: _buildSubList(widget.formalComplaintFile)),
              ],
            ),
          ],
        ),

        // --- Stage 2: Remainder to Company ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: currentIndex >= 2 ? activeCol : inactiveCol,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Remainder to Company ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 2,
                    height: _calculateLineHeight(widget.remainderToCompany),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: LinearProgressIndicator(
                        value: controller3?.value ?? controller3Value,
                        backgroundColor: inactiveCol,
                        color: currentIndex >= 2 ? activeCol : inactiveCol,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(child: _buildSubList(widget.remainderToCompany)),
              ],
            ),
          ],
        ),

        // --- Stage 3: Legal Notice Send ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    // --- FIX: Was >= 4 ---
                    color: currentIndex >= 3 ? activeCol : inactiveCol,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Legal Notice Send ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 2,
                    // --- FIX: Was widget.escalatedEmail ---
                    height: _calculateLineHeight(widget.legalNoticeSend),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: LinearProgressIndicator(
                        value: controller4?.value ?? controller4Value,
                        backgroundColor: inactiveCol,
                        // --- FIX: Was >= 4 ---
                        color: currentIndex >= 3 ? activeCol : inactiveCol,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // --- FIX: Was widget.escalatedEmail ---
                Expanded(child: _buildSubList(widget.legalNoticeSend)),
              ],
            ),
          ],
        ),

        // --- Stage 4: Escalated Email ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    // --- FIX: Was >= 5 ---
                    color: currentIndex >= 4 ? activeCol : inactiveCol,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Escalated Email ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: 2,
                    // --- FIX: Was widget.refunded ---
                    height: _calculateLineHeight(widget.escalatedEmail),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: LinearProgressIndicator(
                        value: controller5?.value ?? controller5Value,
                        backgroundColor: inactiveCol,
                        // --- FIX: Was >= 5 ---
                        color: currentIndex >= 4 ? activeCol : inactiveCol,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // --- FIX: Was widget.refunded ---
                Expanded(child: _buildSubList(widget.escalatedEmail)),
              ],
            ),
          ],
        ),

        // --- Stage 5: Refunded / Closed ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    // --- FIX: Was >= 3 ---
                    color: currentIndex >= 5 ? activeCol : inactiveCol,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Refunded / Closed ",
                        style:
                            widget.headingTitleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        style:
                            widget.headingDateTextStyle ??
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // This step has no line, as per your temp.dart layout
            Padding(
              padding: const EdgeInsets.only(left: 37, top: 10, bottom: 10),
              // --- FIX: Was widget.legalNoticeSend ---
              child: _buildSubList(widget.refunded),
            ),
          ],
        ),
      ],
    );
  }
}
