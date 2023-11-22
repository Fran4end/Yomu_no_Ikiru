import 'package:flutter/material.dart';
import 'package:yomu_no_ikiru/Api/adapter.dart';

class SourceSelector extends StatelessWidget {
  final String sourceName;
  final String imagePath;
  final MangaApiAdapter mangaApi;
  const SourceSelector({
    super.key,
    required this.sourceName,
    required this.imagePath,
    required this.mangaApi,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        height: 33,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                height: 30,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                sourceName,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromRGBO(34, 40, 60, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
