/// List extension
extension ListExtNonNull<T> on List<T> {
  ///Insert [item] between each element
  ///[a,a].gap(b) -> [a,b,a]
  List<T> gap(T item) {
    if (isEmpty) return this;
    final tmp = expand((element) => [element, item]).toList();
    return tmp..removeLast();
  }
}
