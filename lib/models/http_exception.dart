

class HttpException implements Exception{ //Exception is abstract class 
  final String message;
  HttpException(this.message);

  @override 
  String toString(){
    return message;
    //return super.toString(); //Intance of HttpException

  }
}