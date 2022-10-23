//
//  CallOutView.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/21/22.
//

import SwiftUI

struct CallOutView: View {
    
    var annotation: LandmarkAnnotation
    var snapShot: UIImage?
    
    var body: some View {
        VStack{
            if (snapShot != nil) {
                Image(uiImage: snapShot! )
            }
            Text(annotation.address ?? "")
                .font(.body)
                .padding(.bottom)
            HStack{
                Text(annotation.phone ?? "")
                    .font(.body)
                Spacer()
            }
        }
        
    }
}

//struct CallOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CallOutView(annotation:  <#T##LandmarkAnnotation#>)
//    }
//}
