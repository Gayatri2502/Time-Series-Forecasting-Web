// import 'package:flutter/material.dart';
//
// class MyHomePage extends StatelessWidget {
//   int selectedContainerIndex = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Container Selection Demo'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               buildContainer(1),
//               buildContainer(2),
//               buildContainer(3),
//               buildContainer(4),
//             ],
//           ),
//           SizedBox(height: 20),
//           Visibility(
//             visible: selectedContainerIndex == 1,
//             child: ContainerWidget1(),
//           ),
//           Visibility(
//             visible: selectedContainerIndex == 2,
//             child: ContainerWidget2(),
//           ),
//           Visibility(
//             visible: selectedContainerIndex == 3,
//             child: ContainerWidget3(),
//           ),
//           Visibility(
//             visible: selectedContainerIndex == 4,
//             child: ContainerWidget4(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ContainerWidget1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.green,
//       height: 200,
//       child: Center(
//         child: Text('Widget 1'),
//       ),
//     );
//   }
// }
//
// class ContainerWidget2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.orange,
//       height: 200,
//       child: Center(
//         child: Text('Widget 2'),
//       ),
//     );
//   }
// }
//
// class ContainerWidget3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.red,
//       height: 200,
//       child: Center(
//         child: Text('Widget 3'),
//       ),
//     );
//   }
// }
//
// class ContainerWidget4 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue,
//       height: 200,
//       child: Center(
//         child: Text('Widget 4'),
//       ),
//     );
//   }
// }
