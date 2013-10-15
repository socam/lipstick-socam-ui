
//storage.js
// First, let's create a short helper function to get the database connection
function getDatabase() {
     return openDatabaseSync("SocamRSSReader", "1.0", "SocamRSSReader", 100000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    console.log("Storage.initialize()");
    var db = getDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS urls(templateIndex int, isLandscape int(1), url TEXT);');
            tx.executeSql('CREATE TABLE IF NOT EXISTS template(isLandscape int(1), filePath TEXT);');
      });
    console.log("Storage.initialize() END");
}




// This function is used to retrieve an URL from the database
function getTemplate(isLandscape) {
   console.log("Storage.getTemplate isLandscape=" + isLandscape);
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
                      var rs = tx.executeSql('SELECT filePath FROM template where isLandscape=?;', [(isLandscape?1:0)]);

     if (rs.rows.length > 0) {
          res = rs.rows.item(0).filePath;
     } else {
         res = "";
     }
  })
  console.log("Storage.getTemplate=" + res);
  return res
}


// This function is used to write a setting into the database
function setTemplate(isLandscape, filePath) {
    console.log("Storage.setTemplate isLandscape= " + isLandscape + " filePath=" + filePath);
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {

           var rs = tx.executeSql('DELETE FROM template where isLandscape=?;', [(isLandscape?1:0)]);
           console.log("Rows:" + rs.rowsAffected);

           rs = tx.executeSql('INSERT INTO template VALUES (?,?);', [(isLandscape?1:0),filePath]);
           console.log("Rows:" + rs.rowsAffected);
           if (rs.rowsAffected > 0) {
               res = "OK";
           } else {
               res = "Error";
           }

    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    console.log("Storage.setTemplate " + res);
    return res;
}


// This function is used to write a setting into the database
function setURL(templateIndex, isLandscape, url) {
    console.log("Storage.setURL index=" + templateIndex + " isLandscape=" + isLandscape + " URL=" + url);
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {

           tx.executeSql('DELETE FROM urls WHERE templateIndex=? and isLandscape=?;', [templateIndex,(isLandscape?1:0)]);
           var rs = tx.executeSql('INSERT OR REPLACE INTO urls VALUES (?,?,?);', [templateIndex,(isLandscape?1:0),url]);
           console.log("Row affected:" + rs.rowsAffected);
           if (rs.rowsAffected > 0) {
               res = "OK";
           } else {
               res = "Error";
           }
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    console.log("Storage.setURL " + res);
    return res;
}



// This function is used to retrieve an URL from the database
function getURL(templateIndex, isLandscape) {
    console.log("Storage.getURL(" + templateIndex + "," + isLandscape + ")");
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
           var rs = tx.executeSql('SELECT url FROM urls WHERE templateIndex=? and isLandscape=?;', [templateIndex,(isLandscape?1:0)]);
           if (rs.rows.length > 0) {
               res = rs.rows.item(0).url;
           } else {
               res = "";
           }
       })
    return res
}
