import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grapes',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Pear'
  ];

  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = List.from(_suggestions);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 35,
      width: 500,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? Colors.grey[800] : Colors.grey[200],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
            fontSize: 15, color: isDark ? Colors.white : Colors.black),
        onTap: () {
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            height: 200,
            width: 100,
            child: ListView.builder(
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredSuggestions[index],
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                  onTap: () {
                    // Handle suggestion selection
                    // For example, navigate to a details screen
                    // or perform a search action
                    print('Selected: ${_filteredSuggestions[index]}');
                  },
                );
              },
            ),
          );
        },
        onChanged: (value) {
          setState(() {
            // Filter suggestions based on the input value
            _filteredSuggestions = _filterSuggestions(value);
          });
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none, // No border
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: isDark ? Colors.white : Colors.black),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _filteredSuggestions = List.from(_suggestions);
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  List<String> _filterSuggestions(String query) {
    query = query.toLowerCase();
    List<String> filtered = [];

    // Add matching suggestions to the beginning of the list
    for (String suggestion in _suggestions) {
      if (suggestion.toLowerCase().contains(query)) {
        filtered.insert(0, suggestion);
      } else {
        filtered.add(suggestion);
      }
    }

    return filtered;
  }
}
