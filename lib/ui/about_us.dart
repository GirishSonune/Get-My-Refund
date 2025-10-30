import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get_my_refund/ui/home_page.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final Map<int, bool> _expandedStates = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };

  void _toggleExpanded(int index) {
    setState(() {
      _expandedStates[index] = !(_expandedStates[index] ?? false);
    });
  }

  Widget _buildExpandableText(String text, int index) {
    bool isExpanded = _expandedStates[index] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18),
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _toggleExpanded(index),
          child: Text(
            isExpanded ? "Show Less" : "Show More",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset("lib/images/logo.png", fit: BoxFit.contain, height: 50),
            // const SizedBox(width: 25),
            const Text(
              "About Us",
              // style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   color: Color.fromRGBO(91, 193, 172, 1),
              // ),
            ),
          ],
        ),
        // leading: IconButton(
        //   icon: const Icon(Ionicons.chevron_back_outline),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => HomePage(),
        //       ),
        //     );
        //   },
        // ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 25),
          const Center(
            child: Text(
              "About Us",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              "Our core team consists of four professionals and an industry expert, each with over two decades of experience across various industries such as e-commerce, IT, banking, insurance, and finance. We started this initiative with a vision to assist mistreated and dissatisfied customers who have been unfairly deprived of their money. Our team guides you through the available consumer-grievance channels provided by the Government of India, which you can utilize to reclaim your money.   We guide you on how to use official grievance portals such as ombudsman or public complaint systems, and assist you in preparing your documents so you can submit them yourself. Please note that we are not affiliated with any of these agencies, nor do we represent them in any capacity. Our role is purely to guide and assist you in navigating these platforms in accordance with government regulations.",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 50),

          const Center(
            child: Text(
              "Get Your Refund Back",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          // const Center(
          //   child: Text(
          //     "Kind Heart Motive",
          //     style: TextStyle(
          //       color: Color.fromRGBO(91, 193, 172, 1),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _buildExpandableText(
              "Many customers in India have complained about being cheated by various online platforms. After assisting numerous dissatisfied customers offline over the past two decades, we created this online portal where our team of industry experts can guide and assist them through various options available to help them recover their hard-earned money. Our team has long experience across e-commerce, payments, financial services, etc. We guide you through the possible consumer grievance and refund channels so you can seek recovery efficiently. Please note that we are not affiliated with any government agencies such as RBI, SBI, etc., nor do we have any tie-ups with private companies like Air India, Amazon, or Paytm. At GetMyRefund, we help you find solutions to payment-related problems, such as: Money debited twice for a service or product but not refunded A company charging higher interest than promised A company delivering a faulty product but refusing a refund Issues related to recharges, payments, or ticket bookings on various online platforms Any other case where money has been debited from your account but not refunded If you’re facing any of these issues, we are here to assist you!",
              1,
            ),
          ),
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.all(25),
            child: const Center(
              child: Text(
                "Dont Pay Us Anything before you get your Money Back (except in escalation cases involving Forums)",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _buildExpandableText(
              "The best part of connecting with us is that you don't have to pay anything upfront before receiving your refund. You only need to pay a nominal success fee of 10% of the total refund amount, and that too only after the money is credited to your bank account. No matter how big or small your refund issue is or how much money is involved,  Our team of industry experts is here to assist you... we are always available to guide and support you in reclaiming your funds. . You don't have to worry about any upfront costs—we are always available to guide and support you in reclaiming what is rightfully yours.",
              2,
            ),
          ),
          SizedBox(height: 50),

          const Center(
            child: Text(
              "Additional Financial & Other Services",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _buildExpandableText(
              "Apart from handling refund-related issues, we can also help you with various financial and other services. If you need assistance beyond refunds, our team is happy to connect you with the respective industry experts. We can connect you with independent experts for services such as financial guidance, tax assistance, if required. These services are outside our core refund assistance and are handled separately. Please note that these additional services are chargeable directly by them.  All these related matters require an advance fee covering documentation, and  support services. This fee varies based on the merit of the case and the issue involved. If you need additional support, we can connect you with independent experts for further assistance on a fee basis. We are here to help, guide, and connect you with experts in their field so that you are empowered in securing your rights!",
              3,
            ),
          ),
          SizedBox(height: 50),

          const Center(
            child: Text(
              "No Guaranteed Outcome",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _buildExpandableText(
              "Please be aware that accepting your case does not guarantee a refund. The refund of your money depends entirely on the merits of your case. We are not liable for any damages if the company in dispute refuses to refund your money. Our role is solely that of a facilitator—we help you reach out to the highest authority of the concerned company or guide you through the appropriate government channels. The outcome of your case on these portals is entirely dependent on its merit and is not guaranteed by us.",
              4,
            ),
          ),
          SizedBox(height: 50),

          const Center(
            child: Text(
              "Why We Do This",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _buildExpandableText(
              "Through our extensive work with various online payment platforms in India, we have observed that customers are frequently cheated out of their hard-earned money due to multiple reasons, often finding no one willing to listen or assist them in reclaiming their funds. In many cases, customers are unaware of their available options when companies stop responding. We genuinely understand these frustrations and aim to help by providing all available options. However, we also recognize that a timely resolution is crucial. That's why we work alongside you, ensuring every possible step is taken as quickly and efficiently as possible to help you recover your money.",
              5,
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
