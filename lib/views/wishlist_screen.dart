import 'package:flutter/material.dart';
import 'package:interntesting/services/database_wishlist.dart';
import 'package:interntesting/models/posts.dart';
import 'package:interntesting/views/post_detail.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Future<List<Map<String, dynamic>>> _wishlistFuture = DatabaseWishlist().getAllWishlist();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshWishlist() async {
    setState(() {
      _wishlistFuture = DatabaseWishlist().getAllWishlist();
    });
  }

  Future<void> _removeFromWishlist(int id) async {
    try {
      await DatabaseWishlist().deleteWishlist(id);
      _refreshWishlist();
    } catch (e) {
      debugPrint('Error removing from wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWishlist,
        color: const Color(0xFF6366F1),
        child: _buildWishlistList(),
      ),
    );
  }

  Widget _buildWishlistList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _wishlistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No wishlist found'));
        }

        final wishlist = snapshot.data!;
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: wishlist.length,
          itemBuilder: (context, index) {
            final item = wishlist[index];
            return ListTile(
              onTap: () {
                final post = Posts(
                  id: item['post_id'],
                  title: item['title'] ?? '',
                  body: item['body'] ?? '',
                  userId: 0,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostDetail(post: post)),
                );
              },
              title: Text(item['title'] ?? 'No Title'),
              subtitle: Text(item['timestamp'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _removeFromWishlist(item['id']),
              ),
            );
          },
        );
      },
    );
  }
}