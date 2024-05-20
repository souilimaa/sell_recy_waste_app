class Product{
  var id;
  var name;
  var description;
  var categ_id;
  var image;
  var qty_available;
  var seller_id;
  var list_price;
  Product(this.id,this.name,this.description,this.categ_id,this.image,this.qty_available,this.seller_id,this.list_price);
  Product.withoutId(this.name,this.description,this.categ_id,this.image,this.qty_available,this.seller_id,this.list_price);
  String toString() {
    return 'Product{id: $id, name: $name}';
  }
  static Product jsonToProduct(Map<String,dynamic> jsonProduct){
    return Product(
      jsonProduct['id'],
      jsonProduct['name'],
      jsonProduct['description'],
      jsonProduct['categ_id'],
      jsonProduct['image'],
      jsonProduct['qty_available'],
      jsonProduct['seller_id'],
      jsonProduct['list_price'],

    );
  }
}