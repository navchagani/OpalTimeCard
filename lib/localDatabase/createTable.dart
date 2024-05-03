import 'dart:convert';

class CreateTables {
  static String getType(Type type) {
    return switch (type) {
      const (int) => 'INTEGER',
      const (String) => 'TEXT',
      const (double) => 'REAL',
      _ => 'TEXT'
    };
  }

  static Object decodeObject(Object value) {
    return switch (value) {
      const (int) => value,
      const (String) => jsonEncode(value),
      const (double) => jsonEncode(value),
      const (List<dynamic>) => value,
      _ => String
    };
  }

  static String createColumns(Map<String?, Object?> map) {
    String columns = '';
    map.forEach((key, value) {
      columns += '$key ${getType(value.runtimeType)}, ';
    });

    return columns.endsWith(', ')
        ? columns.substring(0, columns.length - 2)
        : columns;
  }

  static String createTable(String tableName, Map<String?, Object?> map) {
    String columns = createColumns(map);
    String table = 'CREATE TABLE IF NOT EXISTS $tableName ($columns)';

    return table;
  }
}
