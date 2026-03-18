import 'package:flutter/material.dart';
import 'package:projeto_despesas/providers/UsuarioProvider.dart';
import '../screens/cadastroScreen.dart';
import 'package:provider/provider.dart';


class Formlogin extends StatefulWidget{
  Formlogin({super.key});

  @override
  State<Formlogin> createState() => _FormLogin();
}

class _FormLogin extends State<Formlogin>{
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool senhaVisivel = false;
  bool isLoading = false;


  @override
  Widget build(BuildContext context){

    return isLoading ? 
      Center(
            child:CircularProgressIndicator(
            color: Colors.white,
          ))
    : Container(
        width: MediaQuery.of(context).size.width, // pega largura total da tela e usa 90%
        height: MediaQuery.of(context).size.height * 0.75, //pega altura total da tela e usa 60%
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50)
          )
        ),
        child: Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset('../assets/images/task_icon.png'),
            ),
            Text('Login',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.email,color: Theme.of(context).colorScheme.primary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                hintText: 'Digite seu email',
                contentPadding: EdgeInsets.all(18)
              ),
              controller: _emailController,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.key,color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      senhaVisivel = !senhaVisivel;
                    });
                  }, 
                  icon: Icon(senhaVisivel ? Icons.visibility : Icons.visibility_off)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                hintText: 'Digite sua senha',
                contentPadding: EdgeInsets.all(18)
              ),
              obscureText: !senhaVisivel,
              controller: _senhaController,
            ),
            SizedBox(height: 16),
            //Expanded(
           //   child: 
            ElevatedButton(
              style: ButtonStyle(
                maximumSize:WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.4,MediaQuery.of(context).size.width * 0.6)) ,
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(18))
              ),
              onPressed:()async{
                setState(() {
                  isLoading = true;
                });
                final provider = Provider.of<Usuarioprovider>(context,listen: false);
                bool resultado = await provider.login(_emailController.text, _senhaController.text);

                if(resultado == false){
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email ou senha invalidos!',style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                }else{
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login,color: Colors.white),
                SizedBox(width: 8),
                Text('Entrar',style: TextStyle(color: Colors.white,fontSize: 16),)
              ],
              )
            ),
            //),
            SizedBox(height: 25),
            TextButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context)=>CadastroScreen()), 
                  (route)=>false
                );
              }, 
              child: Text(
                'Não possui uma conta? Cadastre-se',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
    ),
    );
  }
}