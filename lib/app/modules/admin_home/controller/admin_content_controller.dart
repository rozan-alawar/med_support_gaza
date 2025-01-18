
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxDouble uploadProgress = 0.0.obs;

  // Add this method
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

      String imageUrl = await uploadImage(selectedImage.value!);
      print("Saved!!!!");

      final content = HealthContentModel(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imageUrl:imageUrl, 
      );

      await Future.delayed(Duration(seconds: 1)); 

      contentList.add(content);
      filteredContent.value = contentList;

      CustomSnackBar.showCustomSnackBar(
        title: 'success'.tr,
        message: 'content_saved'.tr,
      );

      clearForm();
      Get.back();

    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'save_error'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> uploadImage(PlatformFile file) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

      // Create storage reference
      final Reference storageRef = _storage.ref().child('article_images/$fileName');

      // Create upload task
      final UploadTask uploadTask = storageRef.putFile(File(file.path!));

      // Track upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      // Wait for upload to complete and get download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;

    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'error'.tr,
        message: 'image_upload_error'.tr,
      );
      throw e;
    } finally {
      uploadProgress.value = 0.0;
    }
  }


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
      // TODO: Implement actual API call
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      final mockData = [
        HealthContentModel(
          id: '1',
          title: 'كيف تحمي نفسك من الإنفلونزا؟',
          content: 'تعرف على أهم الإجراءات الوقائية من إنفلونزا خلال المواسم المختلفة',
          imageUrl: 'assets/images/heart.png',
          // tags: ['صحة', 'وقاية', 'إنفلونزا'],
        ),
        HealthContentModel(
          id: '2',
          title: 'flu_protection'.tr,
          content: 'seasonal_precautions'.tr,
          imageUrl: 'assets/images/heart.png',
          // tags: ['صحة', 'وقاية', 'إنفلونزا'],
        ),
        // Add more mock data
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

  // Future<void> saveContent() async {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   try {
  //     isLoading.value = true;
  //
  //     final content = HealthContentModel(
  //       title: titleController.text.trim(),
  //       content: contentController.text.trim(),
  //     );
  //
  //     // TODO: Implement actual API call
  //     await Future.delayed(Duration(seconds: 1)); // Simulate API call
  //
  //     contentList.add(content);
  //     filteredContent.value = contentList;
  //
  //     CustomSnackBar.showCustomSnackBar(
  //       title: 'Success',
  //       message: 'content_saved'.tr,
  //     );
  //
  //     clearForm();
  //     Get.back();
  //
  //   } catch (e) {
  //     CustomSnackBar.showCustomErrorSnackBar(
  //       title: 'Error',
  //       message: 'save_error'.tr,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    isEditing.value = false;
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