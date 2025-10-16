import 'package:shared_preferences/shared_preferences.dart';

import '../models/vacancy_model.dart';
import '../services/vacancy_services.dart';

class VacancyController {
  final VacancyService _service = VacancyService();

  // State data
  List<VacancyModel> vacancies = [];
  List<VacancyModel> companyVacancies = [];
  bool isLoading = false;
  String? errorMessage;

  // === FETCH ALL VACANCIES (Public) ===
  Future<void> fetchAllVacancies() async {
    isLoading = true;
    errorMessage = null;
    try {
      vacancies = await _service.getAllPositions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  // === FETCH COMPANY VACANCIES (HRD) ===
  Future<void> fetchCompanyVacancies() async {
    isLoading = true;
    errorMessage = null;
    try {
      companyVacancies = await _service.getCompanyPositions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  // === CREATE NEW VACANCY (HRD) ===
  /// Membuat vacancy baru untuk HRD
  Future<VacancyModel?> createVacancy({
    required String positionName,
    required int capacity,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      // Ambil token langsung dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token HRD tidak ditemukan. Silakan login kembali.');
      }

      // Panggil service untuk membuat vacancy
      final newVacancy = await _service.createPosition(
        positionName: positionName,
        capacity: capacity,
        description: description,
        startDate: startDate,
        endDate: endDate,
        token: token,
      );

      if (newVacancy != null) {
        companyVacancies.add(newVacancy);
      }

      return newVacancy;
    } catch (e) {
      errorMessage = e.toString();
      print('Error creating vacancy: $errorMessage');
      return null;
    } finally {
      isLoading = false;
    }
  }

  // === APPLY TO POSITION (Society) ===
  Future<bool> applyToPosition(String positionId) async {
    errorMessage = null;
    try {
      await _service.applyToPosition(positionId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  // === UPDATE APPLICATION STATUS (HRD) ===
  Future<bool> updateApplicantStatus({
    required String applicationId,
    required String status,
  }) async {
    errorMessage = null;
    try {
      await _service.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  // === GET ALL APPLICANTS FOR A POSITION (HRD) ===
  Future<List<dynamic>> getApplicants(String positionId) async {
    errorMessage = null;
    try {
      final applicants = await _service.getApplicants(positionId);
      return applicants;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }
}
