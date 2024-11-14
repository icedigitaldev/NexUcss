import 'package:flutter/material.dart';
import 'package:nexucss/components/pages/postpone/curso_list_postpone.dart';

class PostponeSchedulesPage extends StatelessWidget {
  const PostponeSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: CursoListPostpone(),
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
