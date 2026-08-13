import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _results = [];
  bool _loading = false;

  Future<void> _searchUsers(String query) async {
    final text = query.trim().toLowerCase();

    if (text.isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);

    try {
      final snapshot = await _firestore.collection('users').get();

      final results = snapshot.docs.where((doc) {
        final data = doc.data();
        final name = data['name']?.toString().toLowerCase() ?? '';
        return name.contains(text);
      }).toList();

      if (!mounted) return;

      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'ابحث عن مستخدم',
              border: InputBorder.none,
            ),
            onChanged: _searchUsers,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _results.isEmpty
                ? const Center(
                    child: Text('لا توجد نتائج'),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final data = _results[index].data();

                      final name = data['name']?.toString() ?? 'مستخدم';
                      final photoUrl =
                          data['photoUrl']?.toString() ?? '';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : null,
                          child: photoUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(name),
                        onTap: () {},
                      );
                    },
                  ),
      ),
    );
  }
}
