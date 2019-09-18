

// converte uma data em formato string DD//MM/AAAA 
// para formato DateTime
DateTime rdtDMA10toDate(String data){
return  DateTime.parse(
      data.substring(6)   +  //ano
      data.substring(3,5) +  //mes 
      data.substring(0,2)    //dia
    );
}