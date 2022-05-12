import ballerina/http;
import ballerina/log;

public type Product record { 
    int id;
    string name;
    string description;
    string price;
};

public type NewProduct record {
    string name;
    string description;
    string price;  
};

# Description
#
# + list - Field Description  
# + total - Field Description  
# + offset - Field Description  
# + 'limit - Field Description
public type ProductList record { 
    Product[] list;
    int total;
    int offset;
    int 'limit;
};

Product product1 = {id:1, name:"24' HD Ready LED TV", description:"24 inches HD LED Television with 3year Warranty", 
price:"$320.00"};
Product product2 = {id:2, name:"ABC 5 in 1 Juice Blender", description:"5 in 1 Juice Blender", price:"$20.54"};
Product product3 = {id:3, name:"Women V Neck Blue Tshirt", description:"High quality Cotton V Neck Blue Tshirt", 
price:"$39.37"};
Product product4 = {id:4, name:"XYZ Aloe Vera Herbal Hair Conditioner", description:"XYZ Aloe Vera Rinse-Off Herbal"
+ " Hair Conditioner 200ml", price: "$11.00"};
Product product5 = {id:5, name:"Multifunctional Storage Wardrobe", description:"Multifunctional Wooden Storage Wardrobe", 
price:"$49.61"};

map<Product> productList = { "1" : product1 , "2": product2, "3": product3, "4": product4, "5": product5};

service http:Service /samplestore on new http:Listener(9090) {
    

    resource function get products(http:Caller caller, http:Request req) returns error? {
        http:Response res = new;
        json[] productsJson = [];
        int counter = 0;

        foreach var item in productList {
            json product = {id:item.id, name: item.name, description: item.description, price: item.price};
            productsJson[counter] = product; 
            counter = counter + 1;
        }

        json productListJson = {list:productsJson, total: counter, offset: 0, 'limit:100};
        res.setJsonPayload(productListJson);
        var success = caller->respond(res);

        if (success is error) {
           // log:printError("Error sending response", err = success);
        }

    }


    resource function post products(@http:Payload NewProduct product1 ) returns error? {
        http:Response res = new;
        int newId = productList.length()+1;
        Product newProduct = {id:newId, name:product1.name, description:product1.description, 
        price: product1.price};
        productList[newId.toString()] = newProduct;
        res.setJsonPayload({id:newProduct.id, name: newProduct.name, description: newProduct.description,
        price: newProduct.price});
        // var success = caller->created("Created", res);
        // if (success is error) {
        //     log:printError("Error sending response", err = success);
        // }
    }


    resource function get products/[string orderId](http:Caller caller, http:Request req, int productId) returns error? {
        http:Response res = new;
        string productIdValue = productId.toString();

        if (productList.hasKey(productIdValue)) {
            Product? product = productList[productIdValue];
            if (product is Product) {
                json jProduct = {name: product.name, id: product.id, description: product.description,
                price: product.price};
                res.setJsonPayload(jProduct);
                log:printInfo(jProduct.toJsonString());
            } else {
                json jerr = {code:500, message: "Internal Server Error", description: "Error while getting product"
                + "details for product Id:" + productIdValue};
                res.statusCode = 500;
                
                res.setJsonPayload(jerr);
            }
        } else {
            json jerr = {code:404, message: "Not Found", description: "Invalid product Id"};
            res.statusCode = 404;
            error? contentType = res.setContentType("application/json");
            if contentType is error {

            }
            res.setJsonPayload(jerr);
        }

        var result = caller->respond(res);

        if (result is error) {
           // log:printError("Error sending response", err = result);
        }

    }    

}
