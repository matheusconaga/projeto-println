import 'package:dio/dio.dart';
import 'package:println/core/services/api_service.dart';

class PostService {

  final ApiService api;

  PostService(this.api);

  Future<void> createPost(FormData data) async {
    await api.dio.post("/posts/", data: data);
  }

  Future<void> editPost(String id, FormData data) async {
    await api.dio.put("/posts/$id", data: data);
  }

  Future<void> deletePost(String id) async {
    await api.dio.delete("/posts/$id");
  }

  Future<Response> getFeed(int page) async {
    return await api.dio.get("/posts/feed?page=$page");
  }

}