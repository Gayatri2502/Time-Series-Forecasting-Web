// import 'package:flutter/material {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CSV Files'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: getAllCSVData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               List<Map<String, dynamic>> uploads = snapshot.data!;
//               return ListView.builder(
//                 itemCount: uploads.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> upload = uploads[index];
//                   return ListTile(
//                     title: Text(upload['fileName']),
//                     subtitle: Text(upload['fileUrl']),
//                     onTap: () {
//                       // Handle onTap if needed
//                     },
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
