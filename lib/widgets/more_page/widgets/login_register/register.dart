import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register_textfield.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adminApprovalController =
      TextEditingController();
  final dio = Dio();
  late RestClient client = RestClient(dio);

  bool _isNameValid = true;
  bool _isIdValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isPhoneValid = true;
  bool _isEmailValid = true;
  bool _isAdminApprovalValid = true;

  final String _adminApprovalNumber =
      "1234"; // Change this to your desired admin approval number

  String _serverErrorMessage = '';
  String _nameErrorMessage = '';
  String _idErrorMessage = '';
  String _passwordErrorMessage = '';
  String _confirmPasswordErrorMessage = '';
  String _phoneErrorMessage = '';
  String _emailErrorMessage = '';
  String _adminApprovalErrorMessage = '';

  void _validateName() {
    setState(() {
      _isNameValid = _nameController.text.isNotEmpty;
      _nameErrorMessage = _isNameValid ? '' : '이름을 입력해주세요.';
      _validateInputs();
    });
  }

  void _validateId() {
    setState(() {
      _isIdValid =
          _idController.text.isNotEmpty && _idController.text.length >= 6;
      _idErrorMessage = _idController.text.isEmpty
          ? '아이디를 입력해주세요.'
          : (_idController.text.length < 6 ? '아이디는 6자리 이상이어야 합니다.' : '');
      _validateInputs();
    });
  }

  void _validatePassword() {
    setState(() {
      bool isNotEmpty = _passwordController.text.isNotEmpty;
      bool isValidLength = _passwordController.text.length >= 8;
      bool containsLetters =
          _passwordController.text.contains(RegExp(r'[A-Za-z]'));
      bool containsNumbers =
          _passwordController.text.contains(RegExp(r'[0-9]'));
      _isPasswordValid =
          isNotEmpty && isValidLength && containsLetters && containsNumbers;
      _passwordErrorMessage = isNotEmpty
          ? (isValidLength
              ? (containsLetters
                  ? (containsNumbers ? '' : '비밀번호에는 숫자가 포함되어야 합니다.')
                  : '비밀번호에는 문자가 포함되어야 합니다.')
              : '비밀번호는 8자리 이상이어야 합니다.')
          : '비밀번호를 입력해주세요.';
      _validateInputs();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _isConfirmPasswordValid = _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
      _confirmPasswordErrorMessage =
          _isConfirmPasswordValid ? '' : '비밀번호와 일치하지 않습니다.';
      _validateInputs();
    });
  }

  void _validatePhone() {
    setState(() {
      _isPhoneValid = _phoneController.text.isNotEmpty;
      _phoneErrorMessage = _isPhoneValid ? '' : '전화번호를 입력해주세요.';
      _validateInputs();
    });
  }

  void _validateEmail() {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty &&
          emailRegex.hasMatch(_emailController.text);
      _emailErrorMessage = _emailController.text.isEmpty
          ? '이메일을 입력해주세요.'
          : (_isEmailValid ? '' : '올바른 이메일 형식이 아닙니다.');
      _validateInputs();
    });
  }

  void _validateAdminApproval() {
    setState(() {
      _isAdminApprovalValid =
          _adminApprovalController.text == _adminApprovalNumber;
      _adminApprovalErrorMessage = _adminApprovalController.text.isEmpty
          ? '관리자 승인번호를 입력해주세요.'
          : (_isAdminApprovalValid ? '' : '관리자 승인번호가 일치하지 않습니다.');
      _validateInputs();
    });
  }

  bool _isButtonEnabled = false;

  void _validateInputs() {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    setState(() {
      _isNameValid = _nameController.text.isNotEmpty;
      _isIdValid =
          _idController.text.isNotEmpty && _idController.text.length >= 6;
      _isPasswordValid = _passwordController.text.isNotEmpty &&
          _passwordController.text.length >= 8 &&
          _passwordController.text.contains(RegExp(r'[A-Za-z]')) &&
          _passwordController.text.contains(RegExp(r'[0-9]'));
      _isConfirmPasswordValid = _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
      _isPhoneValid = _phoneController.text.isNotEmpty;
      _isEmailValid = _emailController.text.isNotEmpty &&
          emailRegex.hasMatch(_emailController.text);
      _isAdminApprovalValid =
          _adminApprovalController.text == _adminApprovalNumber;

      // Enable the button only if all validations are met
      _isButtonEnabled = _isNameValid &&
          _isIdValid &&
          _isPasswordValid &&
          _isConfirmPasswordValid &&
          _isPhoneValid &&
          _isEmailValid &&
          _isAdminApprovalValid;
    });
  }

  bool _isErrorMessageVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('계정생성', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 15, 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('계정정보를 입력해주세요!', style: kAgreeTextStyle)),
                  ),
                  RegisterTextField(
                    label: "이름",
                    controller: _nameController,
                    isValid: _isNameValid,
                    errorMessage: _nameErrorMessage,
                    hintText: "본인 이름을 입력",
                    onChanged: (_) => _validateName(),
                  ),
                  RegisterTextField(
                    label: "아이디",
                    controller: _idController,
                    isValid: _isIdValid,
                    errorMessage: _idErrorMessage,
                    hintText: "아이디 입력(6자리 이상)",
                    onChanged: (_) => _validateId(),
                  ),
                  RegisterTextField(
                    label: "비밀번호",
                    controller: _passwordController,
                    isValid: _isPasswordValid,
                    errorMessage: _passwordErrorMessage,
                    hintText: "비밀번호(영문자, 숫자 포함 8자리 이상)",
                    onChanged: (_) => _validatePassword(),
                    isPassword: true,
                  ),
                  RegisterTextField(
                    label: "비밀번호 재확인",
                    controller: _confirmPasswordController,
                    isValid: _isConfirmPasswordValid,
                    errorMessage: _confirmPasswordErrorMessage,
                    hintText: "비밀번호와 동일하게 입력",
                    onChanged: (_) => _validateConfirmPassword(),
                    isPassword: true,
                  ),
                  RegisterTextField(
                    label: "전화번호",
                    controller: _phoneController,
                    isValid: _isPhoneValid,
                    errorMessage: _phoneErrorMessage,
                    hintText: "전화번호 입력",
                    onChanged: (_) => _validatePhone(),
                    keyboardType: TextInputType.number,
                  ),
                  RegisterTextField(
                    label: "Email",
                    controller: _emailController,
                    isValid: _isEmailValid,
                    errorMessage: _emailErrorMessage,
                    hintText: "Email 입력 ex)example@example.com",
                    onChanged: (_) => _validateEmail(),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  RegisterTextField(
                    label: "관리자 승인번호",
                    controller: _adminApprovalController,
                    isValid: _isAdminApprovalValid,
                    errorMessage: _adminApprovalErrorMessage,
                    hintText: "관리자 승인번호 입력",
                    onChanged: (_) => _validateAdminApproval(),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(
                            double.infinity,
                            50)), // Width will be as wide as possible within the container
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 5)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return _isButtonEnabled
                                ? primaryOrange
                                : lightGray1; // 활성화 시 파란색, 비활성화 시 회색
                          },
                        ), // Horizontal padding
                      ),
                      onPressed: _isButtonEnabled
                          ? () {
                        final password = _passwordController.value.text;

                        final uniqueKey = "EQSI@A";
                        final bytes = utf8.encode(password + uniqueKey);
                        final hash = sha256.convert(bytes);

                        final user = {
                          "name": _nameController.value.text,
                          "identification": _idController.value.text,
                          "password": hash.toString(),
                          "phone_number": _phoneController.value.text,
                          "email": _emailController.value.text,
                        };

                        client.postUserInfo(user).then((value) {
                          print('value: ${value}');
                          if (value == "회원 등록이 되었습니다.") {
                            alertMessage("회원 등록이 되었습니다.");
                            // 서버 응답이 성공이면 로그인 화면으로 전환
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login(nextRoute: '')));
                          }
                          else if(value == "같은 아이디가 있습니다."){
                            throw ArgumentError("같은 아이디가 있습니다.");
                          }
                          else {
                            // 기타 에러
                          }
                        }).catchError((onError){
                          alertMessage(onError.toString());
                        });
                      } : null,
                      child: Text('계정 추가',
                          style: (_isButtonEnabled)
                              ? kButtonTextStyle
                              : kUnidentifiedButtonTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
