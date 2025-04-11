import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
    leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
            Get.back();
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.close),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('Clique Ventures Inc. Terms and Conditions'),
                SectionSubtitle('Effective Date: April 2025'),
                Paragraph(
                    'Welcome to Clique! These Terms and Conditions govern your use of the Clique mobile application and website (the "Platform"). By accessing or using Clique, you agree to comply with and be bound by these terms. If you do not agree with these terms, please do not use the Platform.'),
                SectionTitle('1. Acceptance of Terms'),
                Paragraph(
                    'By registering, accessing, or using Clique, you acknowledge that you have read, understood, and agree to these Terms and Conditions, as well as our Privacy Policy.'),
                SectionTitle('2. User Accounts'),
                BulletList([
                  'You must be at least 16 years of age to use Clique.',
                  'You are responsible for maintaining the confidentiality of your account credentials.',
                  'You agree to provide accurate and up-to-date information.',
                  'You may not use another user’s account without permission.'
                ]),
                SectionTitle('3. Content and Usage'),
                BulletList([
                  'Clique allows users to upload, share, and interact with content.',
                  'You affirm that you have the necessary rights to share uploaded content.',
                  'Clique reserves the right to remove inappropriate content.'
                ]),
                SectionTitle('4. Prohibited Activities'),
                BulletList([
                  'No illegal or unauthorized use.',
                  'No spamming or distributing malware.',
                  'No harassment or impersonation.',
                  'No security breaches.',
                ]),
                SectionTitle('5. Intellectual Property'),
                Paragraph(
                    'Clique and its trademarks are protected. Users retain content ownership but grant Clique a usage license.'),
                SectionTitle('6. DMCA Policy'),
                Paragraph(
                    'DMCA notices can be sent to: info@myclique.shop. Repeated copyright violations may result in account termination.'),
                SectionTitle('7. Liability and Disclaimers'),
                Paragraph(
                    'Clique is provided "as is". We are not liable for losses resulting from user-uploaded content.'),
                SectionTitle('8. Termination'),
                Paragraph(
                    'Clique may suspend or terminate violating accounts. Users may delete their accounts at any time.'),
                SectionTitle('9. Subscriptions'),
                BulletList([
                  'Some features may require a subscription.',
                  'Subscriptions auto-renew unless canceled.',
                  'In-app purchases follow app store policies.'
                ]),
                SectionTitle('10. Governing Law'),
                Paragraph(
                    'These terms are governed by the laws of New York.'),
                Divider(height: 32),
                SectionTitle('Privacy Policy'),
                SectionSubtitle('Effective Date: April 2025'),
                BulletList([
                  'We collect: personal info, content, usage, device data.',
                  'Used for platform improvement, personalization, and support.',
                  'Shared only with service providers or legal authorities.',
                  'You can manage or delete your data via your account.'
                ]),
                SectionTitle('Global Privacy Compliance'),
                Paragraph(
                    'We comply with CCPA, GDPR, PIPEDA, LGPD, PDPA, and Australian Privacy Principles.'),
                Divider(height: 32),
                SectionTitle('Child Privacy Policy'),
                Paragraph(
                    'Clique is not for users under 16. Violations involving child safety will be reported to the authorities.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SectionSubtitle extends StatelessWidget {
  final String text;
  const SectionSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    );
  }
}

class Paragraph extends StatelessWidget {
  final String text;
  const Paragraph(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
