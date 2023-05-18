package kvp24_chat.db

import java.sql.{Connection, DriverManager, Statement}

object DbExample {
  def main(args: Array[String]): Unit = {
    // Установка соединения с базой данных
    Class.forName("org.hsqldb.jdbc.JDBCDriver")
    val connection: Connection = DriverManager.getConnection("jdbc:hsqldb:file:./app/src/main/scala/kvp24_chat/db/chatDb", "SA", "")

    // Создание таблицы
    val statement: Statement = connection.createStatement()
    val createTableQuery: String =
      "CREATE TABLE IF NOT EXISTS MESSAGES (" +
        "id INT NOT NULL," +
        "from_user varchar(255) NOT NULL," +
        "to_user varchar(255) NOT NULL," +
        "message varchar(255) NOT NULL," +
        "PRIMARY KEY (id)" +
        ")"
    statement.executeUpdate(createTableQuery)

    // Закрытие соединения
    statement.close()
    connection.close()
  }
}

