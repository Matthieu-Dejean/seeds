import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seeds/pages/views/add_plant_page.dart';

import '../models/plant.dart';

class PlantCategoryPage extends StatelessWidget {
  const PlantCategoryPage({super.key, required this.category});

  final String category;

  Stream<List<Plant>> getRootPlants() {
    final user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance
        .collection('userPlante')
        .where("Type", isEqualTo: category)
        .where("userId", isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Plant.fromJson(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(category),
        ),
        body: StreamBuilder<List<Plant>>(
          stream: getRootPlants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final plants = snapshot.data!;
              return ListView(
                children:
                    plants.map((plant) => buildPlant(plant, context)).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );

  Widget buildPlant(Plant plant, BuildContext context) => ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AddPlantPage.routeName,
            arguments: plant,
          );
        },
        title: Text(plant.nom),
        subtitle: Text(plant.category),
      );
}
