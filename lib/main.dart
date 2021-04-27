import 'package:app05_bucador_gifs/ui/home_page.dart';
import 'package:flutter/material.dart';


/*
https://api.giphy.com/v1/gifs/trending?api_key=r08kFftXVG17roWUlkaaHWNfCSd7J2YP&limit=25&rating=G

https://api.giphy.com/v1/gifs/search?api_key=r08kFftXVG17roWUlkaaHWNfCSd7J2YP&q=cars&limit=25&offset=0&rating=G&lang=en
*/


void main() {
   
   runApp(MaterialApp(
     home: HomePage(),
     theme: ThemeData(hintColor: Colors.white),
     debugShowCheckedModeBanner: false,
     ));
     
     
    
}