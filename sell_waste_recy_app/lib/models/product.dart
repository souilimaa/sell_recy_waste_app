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

}