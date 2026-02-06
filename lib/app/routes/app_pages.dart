import 'package:get/get.dart';

import '../modules/Household/household_binding.dart';
import '../modules/Household/household_view.dart';
import '../modules/ScAI_bot/sc_ai_bot_binding.dart';
import '../modules/ScAI_bot/sc_ai_bot_view.dart';
import '../modules/add_class/add_class_binding.dart';
import '../modules/add_class/add_class_view.dart';
import '../modules/assign_homework/assign_homework_binding.dart';
import '../modules/assign_homework/assign_homework_view.dart';
import '../modules/class_chat/class_chat_binding.dart';
import '../modules/class_chat/class_chat_view.dart';
import '../modules/class_invitation_from_teacher/class_invitation_from_teacher_binding.dart';
import '../modules/class_invitation_from_teacher/class_invitation_from_teacher_view.dart';
import '../modules/class_overview/class_overview_binding.dart';
import '../modules/class_overview/class_overview_view.dart';
import '../modules/class_student/class_student_binding.dart';
import '../modules/class_student/class_student_view.dart';
import '../modules/class_student_details/class_student_details_binding.dart';
import '../modules/class_student_details/class_student_details_view.dart';
import '../modules/class_students_list/class_students_list_binding.dart';
import '../modules/class_students_list/class_students_list_view.dart';
import '../modules/class_teacher/class_teacher_binding.dart';
import '../modules/class_teacher/class_teacher_view.dart';
import '../modules/create_quiz/create_quiz_binding.dart';
import '../modules/create_quiz/create_quiz_view.dart';
import '../modules/upload_document/upload_document_binding.dart';
import '../modules/upload_document/upload_document_view.dart';
import '../modules/class_teacher_details/class_teacher_details_binding.dart';
import '../modules/class_teacher_details/class_teacher_details_view.dart';
import '../modules/class_teacher_details_see_more/class_teacher_details_see_more_binding.dart';
import '../modules/class_teacher_details_see_more/class_teacher_details_see_more_view.dart';
import '../modules/dashboard_student/dashboard_student_binding.dart';
import '../modules/dashboard_student/dashboard_student_view.dart';
import '../modules/dashboard_teacher/dashboard_teacher_binding.dart';
import '../modules/dashboard_teacher/dashboard_teacher_view.dart';
import '../modules/general_evaluation/general_evaluation_binding.dart';
import '../modules/general_evaluation/general_evaluation_view.dart';
import '../modules/subject_evaluation/subject_evaluation_binding.dart';
import '../modules/subject_evaluation/subject_evaluation_view.dart';
import '../modules/edit_profile/edit_profile_binding.dart';
import '../modules/edit_profile/edit_profile_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/landing/landing_binding.dart';
import '../modules/landing/landing_view.dart';
import '../modules/library_student/library_student_binding.dart';
import '../modules/library_student/library_student_view.dart';
import '../modules/learning_student/learning_student_binding.dart';
import '../modules/learning_student/learning_student_view.dart';
import '../modules/learning_subject_detail/learning_subject_detail_binding.dart';
import '../modules/learning_subject_detail/learning_subject_detail_view.dart';
import '../modules/pro_offer/pro_offer_binding.dart';
import '../modules/pro_offer/pro_offer_view.dart';
import '../modules/competence_test/competence_test_binding.dart';
import '../modules/competence_test/competence_test_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/parent_guardian/parent_guardian_binding.dart';
import '../modules/parent_guardian/parent_guardian_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/ressources_student/ressources_student_binding.dart';
import '../modules/ressources_student/ressources_student_view.dart';
import '../modules/ressources_teacher/ressources_teacher_binding.dart';
import '../modules/ressources_teacher/ressources_teacher_view.dart';
import '../modules/signup/signup_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/submissions/submissions_binding.dart';
import '../modules/submissions/submissions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_STUDENT,
      page: () => DashboardStudentView(),
      binding: DashboardStudentBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_STUDENT,
      page: () => ClassStudentView(),
      binding: ClassStudentBinding(),
    ),
    GetPage(
      name: _Paths.RESSOURCES_STUDENT,
      page: () => const RessourcesStudentView(),
      binding: RessourcesStudentBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SC_AI_BOT,
      page: () => const ScsAIBotView(),
      binding: ScsAIBotBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_STUDENT_DETAILS,
      page: () => const ClassStudentDetailsView(),
      binding: ClassStudentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_TEACHER,
      page: () => const DashboardTeacherView(),
      binding: DashboardTeacherBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_TEACHER,
      page: () => const ClassTeacherView(),
      binding: ClassTeacherBinding(),
    ),
    GetPage(
      name: _Paths.RESSOURCES_TEACHER,
      page: () => const RessourcesTeacherView(),
      binding: RessourcesTeacherBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_OVERVIEW,
      page: () => const ClassOverviewView(),
      binding: ClassOverviewBinding(),
    ),
    GetPage(
      name: _Paths.SUBMISSIONS,
      page: () => const SubmissionsView(),
      binding: SubmissionsBinding(),
    ),
    GetPage(
      name: _Paths.ASSIGN_HOMEWORK,
      page: () => const AssignHomeworkView(),
      binding: AssignHomeworkBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_INVITATION_FROM_TEACHER,
      page: () => ClassInvitationFromTeacherView(),
      binding: ClassInvitationFromTeacherBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_TEACHER_DETAILS,
      page: () => const ClassTeacherDetailsView(),
      binding: ClassTeacherDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_TEACHER_DETAILS_SEE_MORE,
      page: () => const ClassTeacherDetailsSeeMoreView(),
      binding: ClassTeacherDetailsSeeMoreBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CLASS,
      page: () => const AddClassView(),
      binding: AddClassBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_CHAT,
      page: () => const ClassChatView(),
      binding: ClassChatBinding(),
    ),
    GetPage(
      name: _Paths.CLASS_STUDENTS_LIST,
      page: () => const ClassStudentsListView(),
      binding: ClassStudentsListBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_QUIZ,
      page: () => const CreateQuizView(),
      binding: CreateQuizBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_DOCUMENT,
      page: () => const UploadDocumentView(),
      binding: UploadDocumentBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_GUARDIAN,
      page: () => const ParentGuardianView(),
      binding: ParentGuardianBinding(),
    ),
    GetPage(
      name: _Paths.HOUSEHOLD,
      page: () => const HouseholdView(),
      binding: HouseholdBinding(),
    ),
    GetPage(
      name: _Paths.GENERAL_EVALUATION,
      page: () => const GeneralEvaluationView(),
      binding: GeneralEvaluationBinding(),
    ),
    GetPage(
      name: _Paths.SUBJECT_EVALUATION,
      page: () => const SubjectEvaluationView(),
      binding: SubjectEvaluationBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.LIBRARY_STUDENT,
      page: () => const LibraryStudentView(),
      binding: LibraryStudentBinding(),
    ),
    GetPage(
      name: _Paths.LEARNING_STUDENT,
      page: () => const LearningStudentView(),
      binding: LearningStudentBinding(),
    ),
    GetPage(
      name: _Paths.LEARNING_SUBJECT_DETAIL,
      page: () => const LearningSubjectDetailView(),
      binding: LearningSubjectDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRO_OFFER,
      page: () => const ProOfferView(),
      binding: ProOfferBinding(),
    ),
    GetPage(
      name: _Paths.COMPETENCE_TEST,
      page: () => const CompetenceTestView(),
      binding: CompetenceTestBinding(),
    ),
  ];
}
