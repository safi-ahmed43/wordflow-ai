
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyPlaceholder extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.generating_tokens,color: Colors.deepPurpleAccent,size: 60,),
          Text('Generate a new conversations',style: GoogleFonts.blackOpsOne(
              color: Colors.deepPurpleAccent,
              fontSize: 20
          ),)
        ],
      ),
    );
  }
}
