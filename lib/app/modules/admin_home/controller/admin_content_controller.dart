import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../data/models/health_content_model.dart';
import 'dart:io';

class ContentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxList<HealthContentModel> contentList = <HealthContentModel>[].obs;
  final RxList<HealthContentModel> filteredContent = <HealthContentModel>[].obs;
  final Rxn<PlatformFile> selectedImage = Rxn<PlatformFile>();

  @override
  void onInit() {
    super.onInit();
    loadContent();
    searchController.addListener(_onSearchChanged);
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

  Future<void> saveContent() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedImage.value == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'image_required'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final String imagePath = selectedImage.value!.path!;

      final content = HealthContentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imageUrl: imagePath,
      );

      contentList.add(content);
      filteredContent.value = contentList;
      Get.back();

      CustomSnackBar.showCustomSnackBar(
        title: 'success'.tr,
        message: 'content_saved'.tr,
      );


    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'save_error'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchChanged() {
    if (searchController.text.isEmpty) {
      filteredContent.value = contentList;
      return;
    }

    final query = searchController.text.toLowerCase();
    filteredContent.value = contentList.where((content) {
      return content.title.toLowerCase().contains(query) ||
          content.content.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> loadContent() async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1)); // Simulate loading

      final mockData = [
        HealthContentModel(
          id: '1',
          title: 'كيف تحمي نفسك من الإنفلونزا؟',
          content: 'تعرف على أهم الإجراءات الوقائية من إنفلونزا خلال المواسم المختلفة',
          imageUrl: 'assets/images/heart.png',
        ),
        HealthContentModel(
          id: '2',
          title: 'flu_protection'.tr,
          content: 'seasonal_precautions'.tr,
          imageUrl: 'assets/images/heart.png',
        ),
      ];

      contentList.value = mockData;
      filteredContent.value = mockData;

    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to load content: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
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

  Future<void> updateArticle(String id) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final updatedContent = HealthContentModel(
        id: id,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imageUrl: selectedImage.value?.path ??
            contentList.firstWhere((element) => element.id == id).imageUrl,
      );

      final index = contentList.indexWhere((element) => element.id == id);
      if (index != -1) {
        contentList[index] = updatedContent;
        filteredContent.value = contentList;

        // First navigate back
        Get.back();

        // Then show success message
        await Future.delayed(Duration(milliseconds: 300));  // Small delay to ensure navigation is complete
        CustomSnackBar.showCustomSnackBar(
          title: 'success'.tr,
          message: 'article_updated'.tr,
        );
      }

      clearForm();

    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'update_error'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }
}