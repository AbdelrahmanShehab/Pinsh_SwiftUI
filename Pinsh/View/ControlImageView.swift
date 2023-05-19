//
//  ControlImageView.swift
//  Pinsh
//
//  Created by Abdelrahman Shehab on 04/04/2023.
//

import SwiftUI

struct ControlImageView: View {

    let icon: String
    
    var body: some View {
        
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct CntrolImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "minus.magnifyingglass")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
