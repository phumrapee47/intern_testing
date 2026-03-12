import 'package:flutter/material.dart';
import 'package:interntesting/services/database_helper.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:interntesting/models/posts.dart';
import 'package:interntesting/views/post_detail.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  Future<List<Map<String, dynamic>>> _historyFuture = DatabaseHelper().getAllHistory();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _historyFuture = DatabaseHelper().getAllHistory();
    });
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reading history",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF6366F1),
        child: _buildHistoryList(),
      ),
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No history found'));
        }

        final historyList = snapshot.data!;
        final groupedHistory = _groupHistoryByDate(historyList);
        final dates = groupedHistory.keys.toList();

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: dates.length,
            itemBuilder: (context, dateIndex) {
            final date = dates[dateIndex];
            final items = groupedHistory[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(date),
                ...items.map((item) => _buildHistoryItem(item)).toList(),
              ],
            );
          },
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupHistoryByDate(
    List<Map<String, dynamic>> history,
  ) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var item in history) {
      final timestampStr = item['timestamp'] as String?;
      if (timestampStr == null) continue;

      final date = DateTime.parse(timestampStr);
      final dayOnly = DateTime(date.year, date.month, date.day);

      String key;
      if (dayOnly == today) {
        key = 'Today';
      } else if (dayOnly == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM dd, yyyy').format(dayOnly);
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Widget _buildDateHeader(String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFF1F5F9),
      child: Text(
        date,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    final timestamp = DateTime.parse(history['timestamp']);
    final relativeTime = timeago.format(timestamp);

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: GestureDetector(
        onTap: () {
          final post = Posts(
            id: history['post_id'],
            title: history['title'] ?? '',
            body: history['body'] ?? '',
            userId: history['user_id'] ?? 0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostDetail(post: post)),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(
              Icons.article_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
          title: Text(
            history['title'] ?? 'No Title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    relativeTime,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${history['latitude']?.toStringAsFixed(4)}, ${history['longitude']?.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
            onPressed: () async {
              await DatabaseHelper().deleteHistory(history['id']);
              _handleRefresh();
            },
          ),
        ),
      ),
    );
  }
}
