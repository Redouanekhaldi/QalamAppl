
class Services{

  String convert(int n){
    String res;
    var x;
    
    if(n>= 1000 && n< 1000000){
      x= (n-(n%1000))/1000;
      res=x.toString()+'K';
    }else{
      if(n>=1000000){
       // x= (n/1000000) as int;
        x=(n-(n%1000000))/1000000;
        res=x.toString()+'M';
      }else{
        res=n.toString();
      }
    }
    return res;
  }


}