import 'db_service.dart';

class DBHelper {
  final DBService _dbService = DBService();

  // Insert data into the database
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _dbService.database;
    return await db.insert(table, data);
  }

  // Query the database
  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await _dbService.database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  // Update a record in the database
  Future<int> update(String table, Map<String, dynamic> data,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await _dbService.database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  // Delete a record from the database
  Future<int> delete(
      String table, String whereClause, List<dynamic> whereArgs) async {
    final db = await _dbService.database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  // Get all bookings for a user
  Future<List<Map<String, dynamic>>> getBookingsByUser(String userId) async {
    final db = await _dbService.database;
    return await db.query(
      'tourbook',
      columns: [
        'bookid',
        'tourpackage',
        'tourstartdate',
        'tourenddate',
        'bookdate',
        'booktime',
        'nopeople',
        'price'
      ],
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  // Fetch all user bookings for Admin (using JOIN)
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final db = await _dbService.database;
    String query = '''
    SELECT 
      users.name, 
      users.username, 
      tourbook.tourpackage, 
      tourbook.bookdate, 
      tourbook.booktime, 
      tourbook.tourstartdate, 
      tourbook.tourenddate
    FROM 
      users
    JOIN 
      tourbook 
    ON 
      users.userid = tourbook.userid
  ''';
    return await db.rawQuery(query);
  }

  // Get specific booking details by booking ID
  Future<Map<String, dynamic>> getBookingById(int bookingId) async {
    final db = await _dbService.database;
    var result = await db.query(
      'tourbook',
      where: 'bookid = ?',
      whereArgs: [bookingId],
    );
    return result.isNotEmpty ? result.first : {};
  }

  // Update a booking
  Future<int> updateBooking(
      int bookingId, Map<String, dynamic> updatedData) async {
    final db = await _dbService.database;
    try {
      return await db.update(
        'tourbook',
        updatedData,
        where: 'bookid = ?',
        whereArgs: [bookingId],
      );
    } catch (e) {
      print('Error updating booking: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'userid = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first; // Return the first matching user record
    }
    return null; // Return null if no user found
  }
}
