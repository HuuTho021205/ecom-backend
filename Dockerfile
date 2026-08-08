#Multi-Stage
#( AS tức là đặt tên cho giai đoạn 1 là builder)
FROM eclipse-temurin:17-jdk-alpine AS builder
#Tạo thư mục app và đứng ở đó
WORKDIR /app
#Copy toàn bộ thư mục .mvn sau đó tạo 1 thư mục có tên là .mvn ngay tại chỗ đang đứng (tức là thư mục app)
#Sau đó cho toàn bộ nội dung của thư mục gốc vào thư mục mới tạo
COPY .mvn/ .mvn
#Copy mvnw , pom.xml vào thư mục đang đứng hiện tại (app)
COPY mvnw pom.xml ./
#Tải thư viện trước (Cache layer) nếu thư viện không có gì thay đổi thì docker không tải lại là lấy xài luôn
RUN ./mvnw dependency:go-offline

COPY src ./src
#Clean xóa các file rác nếu có, package dịch code sang .class rồi đóng thành .jar
#-DskipTests bỏ các kiểm thử tự động (Unit Test)
RUN ./mvnw clean package -DskipTests

#Giai đoạn 2 ( runner)
#Sử dụng JRE (Java Runtime Environment) thay vì JDK.
#JRE siêu nhẹ vì nó đã bị cắt bỏ toàn bộ công cụ biên dịch code
#Biên dịch ở giai đoạn 1 rồi nên không cần nữa
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

#Copy file jar đã được biên dịch ở giai đoạn builder rồi đổi tên thành app.jar
COPY --from=builder /app/target/*.jar app.jar

#Mở cổng kết nối
EXPOSE 8009
#java khởi động máy ảo jvm
#-jar là 1 cờ (flag) để báo cho jvm biết đây là 1 file jar
#app.jar có nghĩa là tìm file có tên app.jar để chạy
ENTRYPOINT ["java", "-jar", "app.jar"]

