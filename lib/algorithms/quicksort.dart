import 'package:todo_v2/model/Todo.dart';

 List<Todo> quickSort(List<Todo> a) {
  if (a.length <= 1) {
    return a;
  }
 
  var pivot = a[0];
  List<Todo> less = [];
  List<Todo> more = [];
  List<Todo> pivotList = [];
 
  // Partition
  a.forEach((var i){
    if (DateTime.parse(i.dateExpire).compareTo(DateTime.parse(pivot.dateExpire)) < 0) {
      less.add(i);
    } else if (DateTime.parse(i.dateExpire).compareTo(DateTime.parse(pivot.dateExpire))  > 0) {
      more.add(i);
    } else {
      pivotList.add(i);
    }
  });
 
  // Recursively sort sublists
  less = quickSort(less);
  more = quickSort(more);
 
  // Concatenate results
  less.addAll(pivotList);
  less.addAll(more);
  return less;
}