part of 'pages.dart';

class FeePage extends StatefulWidget {
  const FeePage({super.key});

  @override
  State<FeePage> createState() => _FeePageState();
}

class _FeePageState extends State<FeePage> {

  ///
  bool isLoading = false;

  dynamic tipeKurir;
  
  dynamic provinceData;
  dynamic provinceDataOrigin;
  dynamic provinceDataDestination;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;

  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;

  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provIdOrigin;

  dynamic getFees;
  TextEditingController berat = TextEditingController();
  
  List<Costs> costData = [];

  Future<dynamic> getProvinces() async {

    dynamic province;

    await MasterDataService.getProvince().then((value) {

      setState(() {
        province = value;
        ///
        isLoading = false;
      });
    });
    return province;
  }


  Future<List<City>> getCities(var provId) async {
    ////
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<List<Costs>> getCosts(var originID, var destinationID, var weight, var courier) async {
    ////
    // dynamic costs;
    await MasterDataService.getCosts(originID, destinationID, weight, courier).then((value) {
      setState(() {
        costData = value;
      });
    });

    return costData;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    provinceData = getProvinces(); ////
    // cityDataOrigin = getCities("2");

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,               
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    
                    children: [
                      Row(
                        children: [ 
                          Container(
                          width: 150,
                          child: DropdownButton<String>(
                            value: tipeKurir,
                            hint: tipeKurir == null
                              ? const Text("Pilih Kurir")
                              : Text(tipeKurir),
                            onChanged: (String? newValue) {
                              setState(() {
                                tipeKurir = newValue!;
                              });
                            },
                            items: <String>['jne', 'pos', 'tiki']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ),
                        Container(
                          width: 150,  // Adjust width as needed
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Masukkan Berat (gr)",
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your weight';
                              }
                                return value;
                            },
                            controller: berat,
                          )
                        ),

                        ]
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Text(
                            "Origin"
                            )
                          ],
                      ),

                      Row(
                        children: [
                          Container(
                            width: 180,
                            child: FutureBuilder<dynamic>(
                              future: provinceData,
                              builder: (context, snapshot){
                                if (snapshot.hasData){
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedProvinceOrigin,
                                    icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceOrigin == null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceOrigin.province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child:
                                                  Text(value.province.toString()));
                                        }).toList(),
                                    onChanged: (newValue){
                                      setState(() {
                                        selectedProvinceOrigin = newValue;
                                        cityDataOrigin = getCities(selectedProvinceOrigin.provinceId.toString());
                                      });
                                    });
                                }else if (snapshot.hasError){
                                  return Text("Tidak ada data");
                                }
                                return UiLoading.loadingSmall();
                              } 
                            ),
                          ),
                          Container(
                            width: 180,
                            child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityOrigin == null
                                            ? Text('Pilih kota')
                                            : Text(selectedCityOrigin.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child:
                                                  Text(value.cityName.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityOrigin = newValue;
                                            cityIdOrigin =
                                                selectedCityOrigin.cityId;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }
                                  return UiLoading.loadingSmall();
                                }),
                          )
                        ]
                      ),

                      Row(
                        children: [
                          Text(
                            "Destination")
                          ],
                      ),

                      Row(
                        children: [
                          Container(
                            width: 180,
                            child: FutureBuilder<dynamic>(
                              future: provinceData,
                              builder: (context, snapshot){
                                if (snapshot.hasData){
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedProvinceDestination,
                                    icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceDestination == null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceDestination.province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child:
                                                  Text(value.province.toString()));
                                        }).toList(),
                                    onChanged: (newValue){
                                      setState(() {
                                        selectedProvinceDestination = newValue;
                                        cityDataDestination = getCities(selectedProvinceDestination.provinceId.toString());
                                      });
                                    });
                                }else if (snapshot.hasError){
                                  return Text("Tidak ada data");
                                }
                                return UiLoading.loadingSmall();
                              } 
                            ),
                          ),

                          Container(
                            width: 100,
                            child: FutureBuilder<List<City>>(
                              future: cityDataDestination,
                              builder: (context, snapshot){
                                if (snapshot.hasData){
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityDestination,
                                    icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityDestination == null
                                            ? Text('Pilih Kota')
                                            : Text(selectedCityDestination.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child:
                                                  Text(value.cityName.toString()));
                                        }).toList(),
                                    onChanged: (newValue){
                                      setState(() {
                                        selectedCityDestination = newValue;
                                        cityIdDestination =
                                                selectedCityDestination.cityId;
                                      });
                                    });
                                }else if (snapshot.hasError){
                                  return Text("Tidak ada data");
                                }
                                return UiLoading.loadingSmall();
                              } 
                            ),
                          ),
                        ]
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),
                            onPressed: () async{
                              setState(() {
                                isLoading = true;
                              });
                              getFees = await getCosts(
                                cityIdOrigin,
                                cityIdDestination,
                                berat.text,
                                tipeKurir,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                              'Hitung Estimasi Harga', 
                              style: TextStyle(
                                color: Colors.white
                              )
                            ),
                          )
                        ]
                      ),
                      // Row(children: [
                      //   Container(
                      //   width: double.infinity,
                      //   height: double.infinity,
                      //   child: costData.isEmpty
                      //     ? const Align(
                      //       alignment: Alignment.center,
                      //       child: Text("Data kosong"),
                      //     )
                      //     : ListView.builder(
                      //       itemCount: costData.length,
                      //       itemBuilder: (context, index) {
                      //         return CardCosts(costData[index]);
                      //       }))
                      // ],)
                    ],

                  ),
                )
              ),
              Flexible(
                flex: 3,
                child: Container(
                width: double.infinity,
                height: double.infinity,
                child: costData.isEmpty
                  ? const Align(
                    alignment: Alignment.center,
                    child: Text("Data kosong"),
                  )
                  : ListView.builder(
                    itemCount: costData.length,
                    itemBuilder: (context, index) {
                      return CardCosts(costData[index]);
                    })),
                ),
            ],
          ),

          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
