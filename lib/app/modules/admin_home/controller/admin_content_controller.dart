import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/data/api_services/articles_api.dart';
import 'package:med_support_gaza/app/data/models/article_model.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../data/models/health_content_model.dart';

class ContentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxList<Article> contentList = <Article>[].obs;
  final RxList<Article> filteredContent = <Article>[].obs;
  final Rxn<PlatformFile> selectedImage = Rxn<PlatformFile>();
  RxInt articlesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadContent();
    // searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        selectedImage.value = result.files.first;
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'image_pick_error'.tr,
      );
    }
  }

  //------------------------ GET ARTICLES -----------------------------

  void loadContent() {
    ArticlesAPIService.getArticles(
      onSuccess: (response) {
        isLoading.value = false;
        ArticleResponse articlesResponse =
            ArticleResponse.fromJson(response.data);
        contentList.value = articlesResponse.articles;
        filteredContent.value = contentList;
        isLoading.value = false;
        articlesCount.value = contentList.length;
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ ADD ARTICLE -----------------------------
  Future<void> addArticle() async {
    if (!formKey.currentState!.validate()) return;

    ArticlesAPIService.addArticle(
        title: titleController.text.trim(),
        summary: "",
        content: contentController.text.trim(),
        selectedImage: selectedImage.value!,
        onSuccess: (response) {
          print(response);
          isLoading.value = false;
          CustomSnackBar.showCustomSnackBar(
            title: 'success'.tr,
            message: 'article_added'.tr,
          );
          loadContent();
          Get.back();
          clearForm();
        },
        onError: (error) {
          isLoading.value = false;

          CustomSnackBar.showCustomErrorSnackBar(
            title: 'error'.tr,
            message: error.message.tr,
          );
        },
        onLoading: () {
          isLoading.value = true;
        });
  }

  //------------------------ UPDATE ARTICLE -----------------------------
  Future<void> updateArticle(String id) async {
    if (!formKey.currentState!.validate()) return;

    ArticlesAPIService.updateArticle(
        articleId: id,
        summary: "",
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        image: selectedImage.value?.path ??
            contentList.firstWhere((element) => element.id == id).image,
        onSuccess: (response) {
          isLoading.value = false;

          CustomSnackBar.showCustomSnackBar(
            title: 'success'.tr,
            message: 'article_updated'.tr,
          );
          loadContent(); // Reload content list after updating
          Get.back();
        },
        onError: (error) {
          isLoading.value = false;

          CustomSnackBar.showCustomErrorSnackBar(
            title: 'error'.tr,
            message: error.message.tr,
          );
        },
        onLoading: () {
          isLoading.value = true;
        });
  }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    selectedImage.value = null;
    isEditing.value = false;
    Get.back();
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'title_required'.tr;
    }
    return null;
  }

  String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'content_required'.tr;
    }
    return null;
  }

}
