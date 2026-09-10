import { ChangeDetectorRef, Component } from '@angular/core'
import { FromzaChartsService } from '../../dashboards/shared/fromza-charts.service';
import { DLService } from "../../shared/dl.service";
import * as moment from 'moment/moment';
import { Observable } from 'rxjs';
import { CoreService } from '../../core/shared/core.service'
@Component({
  selector: 'my-app',
  templateUrl: "./dashboard-home.html"
})


export class DashboardHomeComponent {

  public dsbStats: any = "";
  public currentDate: string = "";
  public showCountryMap:boolean=true;
  constructor(public fromzaCharts: FromzaChartsService, public dlService: DLService,public coreService: CoreService,public changeDetector: ChangeDetectorRef) {
    this.currentDate = moment().format("DD-MM-YYYY");
    this.showCountryMap=this.coreService.showCountryMapOnLandingPage;
  }

  ngOnInit() {

    this.LoadDsbStatistics();
    this.LoadPatientMap();
    this.LoadDepartmentAppts();
  }
  ngAfterViewChecked() {
    this.showCountryMap=this.coreService.showCountryMapOnLandingPage;
  }
  LoadDsbStatistics() {
    this.dlService.Read("/Reporting/HomeDashboardStats")
      .map(res => res)
      .subscribe(res => {
        if (res.Status == "OK" && res.Results.JsonData) {
          let parsedData = JSON.parse(res.Results.JsonData);
          if (parsedData && parsedData.length > 0) {
            this.dsbStats = parsedData[0];
            console.log(this.dsbStats);
          }
        }
        else {
          this.dsbStats = "";
        }
      },
        err => {
          alert(err.ErrorMessage);

        });
  }

  LoadPatientMap() {
    this.dlService.Read("/Reporting/PatientZoneMap")
      .map(res => res)
      .subscribe(res => {
        try {
          if (res && res.Results && res.Results.JsonData) {
            let dataToParse: Array<any> = JSON.parse(res.Results.JsonData);
            if (dataToParse && dataToParse.length > 0) {
              let mapAreas = dataToParse.map(d => {
                return { id: d.MapAreaCode, value: d.PatientCount };
              });
              this.fromzaCharts.Home_Map_PatientDistributionByZone("dvZoneWisePatientMap", mapAreas);
            }
          }
        } catch (e) {
          console.warn("PatientZoneMap data unavailable, skipping map render.");
        }
      },
        err => {
          console.warn("PatientZoneMap error (non-fatal):", err);
        });
  }

  LoadDepartmentAppts() {
    this.dlService.Read("/Reporting/DepartmentAppointmentsTotal")
      .map(res => res)
      .subscribe(res => {
        //sud:25sept'19--below line was giving issue because it doesn't get JsonData everytime.
        if (res.Results && res.Results.JsonData) {
          let dataToParse: Array<any> = JSON.parse(res.Results.JsonData);
          let formattedData = dataToParse.map(d => {
            return { department: d.DepartmentName, apptCount: d.AppointmentCount };
          });

          this.fromzaCharts.Home_Pie_DepartmentWiseAppointmentCount("dvPieChart", formattedData);
        }

      },
        err => {
          alert(err.ErrorMessage);

        });
  }

}

