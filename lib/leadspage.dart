import 'package:filter_task/getdata.dart';
import 'package:filter_task/lead.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class LeadTable extends StatefulWidget {
  const LeadTable({super.key, required this.token});
  final token;

  @override
  State<LeadTable> createState() => LeadTableState();
}

class LeadTableState extends State<LeadTable> {
  List<Map<String, String>> leadData = [];

  final List<String> filterFields = [
    'lastName',
    'leadOwner',
    'contact',
    'createdAt',
    'email',
    'state'
  ];

  List<Map<String, String>> filteredLeads = [];

  TextEditingController filterController = TextEditingController();

  String? selectedField;


  late Future<List<Lead>> futureLeads;
  @override
  void initState() {
    super.initState();
    futureLeads = fetchLeads(widget.token).then((leads) {
      setState(() {
        leadData = leads.map((lead) {
          return {
            "lastName": lead.lastName.toString(),
            "owner": lead.leadOwner.toString(),
            "phoneNumber": lead.phoneNumber.toString(),
            "email": lead.email.toString(),
            "state": lead.state.toString(),
            "createdAt": lead.createdAt.toString(),
          };
        }).toList();

        filteredLeads = leadData;
      });
      return leads;
    });
  }


  final List<Map<String, String>> appliedFilters = [];

  //  Function to apply the filters
  void applyFilters() async {
    String query = '';
    for (var filter in appliedFilters) {
      query += '${filter['field']}=${filter['value']}&';
    }

    query = query.isNotEmpty ? query.substring(0, query.length - 1) : query;

    futureLeads = filterLeads(widget.token, query).then((leads) {
      // Convert the fetched leads into the expected format
      setState(() {
        leadData = leads.map((lead) {
          return {
            "lastName": lead.lastName.toString(),
            "owner": lead.leadOwner.toString(),
            "phoneNumber": lead.phoneNumber.toString(),
            "email": lead.email.toString(),
            "state": lead.state.toString(),
            "createdAt": lead.createdAt.toString(),
          };
        }).toList();
        filteredLeads = leadData;
      });
      return leads; 
    });

    print(query);
      }

  //  to clear filters
  void clearFilters() {
    setState(() {
      appliedFilters.clear();
    });
  }
// to add filter
  void addFilter(String field, String value) {
    setState(() {
      appliedFilters.add({'field': field, 'value': value});
      print(appliedFilters);
    });
  }

  void removeFilter(int index) {
    setState(() {
      appliedFilters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        title: const Text('Katyayani'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          // Filter ki UI
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appliedFilters.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text(
                            '${appliedFilters[index]['field']}: ${appliedFilters[index]['value']}'),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () => removeFilter(index),
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: const Text('Select Filter Field'),
                        value: selectedField,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedField = newValue;
                          });
                        },
                        items: filterFields
                            .map<DropdownMenuItem<String>>((String field) {
                          return DropdownMenuItem<String>(
                            value: field,
                            child: Text(field),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: filterController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Filter Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.blueAccent),
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder())),
                      onPressed: () {
                        if (selectedField != null &&
                            filterController.text.isNotEmpty) {
                          addFilter(selectedField!, filterController.text);
                          filterController.clear(); 
                        }
                      },
                      child: const Text(
                        'Add Filter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.blueAccent),
                        shape:
                            WidgetStatePropertyAll(RoundedRectangleBorder())),
                    onPressed: appliedFilters.isNotEmpty ? applyFilters : null,
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.blueAccent),
                        shape:
                            WidgetStatePropertyAll(RoundedRectangleBorder())),
                    onPressed: appliedFilters.isNotEmpty ? clearFilters : null,
                    child: const Text(
                      'Clear All Filters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Lead Table",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
// UI FOR THE TABLE
          Expanded(
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: const [
                DataColumn(label: Text('Last Name')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Phone Numbers')),
                DataColumn(label: Text('Emails')),
                DataColumn(label: Text('State')),
                DataColumn(label: Text('Created At')),
              ],
              rows: filteredLeads.map((lead) {
                return DataRow(
                  onSelectChanged: (bool? selected) {
                    if (selected != null && selected) {
                      print('Selected ${lead['lastName']}');
                    }
                  },
                  cells: [
                    DataCell(Text(lead['lastName']?.toString() ?? 'N/A')),
                    DataCell(Text(lead['owner']?.toString() ?? 'N/A')),
                    DataCell(Text(lead['phoneNumber']?.toString() ?? 'N/A')),
                    DataCell(Text(lead['email']?.toString() ?? 'N/A')),
                    DataCell(Text(lead['state']?.toString() ?? 'N/A')),
                    DataCell(Text(lead['createdAt']?.toString() ?? 'N/A')),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
