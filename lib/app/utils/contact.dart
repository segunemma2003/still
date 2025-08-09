import '/app/models/contact_info.dart';

List<String> _getSearchSuggestions(
    String query, List<String> recentSearches, List<ContactInfo> contactList) {
  List<String> suggestions = [];

  // Add recent searches that match
  for (String recent in recentSearches) {
    if (recent.toLowerCase().contains(query.toLowerCase())) {
      suggestions.add(recent);
    }
  }

  // Add contact names that match
  for (var contact in contactList) {
    if (contact.name?.toLowerCase().contains(query.toLowerCase()) ?? false) {
      suggestions.add(contact.name!);
    }
  }

  return suggestions.take(3).toList(); // Limit to 3 suggestions
}
