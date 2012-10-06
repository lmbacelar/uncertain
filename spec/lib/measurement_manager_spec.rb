require_relative '../../lib/measurement_manager'

describe MeasurementManager do
  context 'Uncertainty calculations as per EA-4/02' do
    # EXAMPLES FROM EA-4/02
    #
    # S2 CALIBRATION OF A WEIGHT OF NOMINAL VALUE 10 KG
    # Simple example
    # NOTE: k, uexp of this example have been corrected, as EA/4-02 assumes k=2, which does not hold when checking
    #       using Welsh-Satterthwaite
    let(:s2_data) { [ stub(ux: 2.25e-2, c: 1, v: Float::INFINITY, dist: 'N'), 
                      stub(ux: 8.95e-3, c: 1, v: Float::INFINITY, dist: 'R'), 
                      stub(ux: 1.44e-2, c: 1, v: 2,               dist: 'N'), 
                      stub(ux: 5.77e-3, c: 1, v: Float::INFINITY, dist: 'R'), 
                      stub(ux: 5.77e-3, c: 1, v: Float::INFINITY, dist: 'R') ] }

    let(:s2_uy) { 2.93e-2 }; let(:s2_k) { 2.08 }; let(:s2_uexp) { 6.1e-2 }

    # S3 CALIBRATION OF NOMINAL 10 kOHM STANDARD RESISTOR
    # Some sensitivity Coefficients differ from 1
    let(:s3_data) { [stub(ux: 2.50e-3, c: 1,   v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 5.80e-3, c: 1,   v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 1.60e-3, c: 1,   v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 3.20e-3, c: 1,   v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 4.10e-7, c: 1e4, v: Float::INFINITY, dist: 'T'), 
                     stub(ux: 7.00e-8, c: 1e4, v: 4,               dist: 'N') ] } 
    let(:s3_uy) { 8.33e-3 }; let(:s3_k) { 2.00 }; let(:s3_uexp) { 1.7e-2 }

    # S4 CALIBRATION OF A GAUGE BLOCK OF NOMINAL LENGTH 50 MM
    # Special type distribution
    let(:s4_data) { [stub(ux: 1.50e-8, c: 1,        v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 1.73e-8, c: 1,        v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 5.37e-9, c: 1,        v: 4,               dist: 'N'), 
                     stub(ux: 1.85e-8, c: 1,        v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 2.89e-2, c: -5.75e-7, v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 2.36e-7, c: 5.00e-2,  v: Float::INFINITY, dist: 'X'), 
                     stub(ux: 3.87e-9, c: -1,       v: Float::INFINITY, dist: 'R') ] }
    let(:s4_uy) { 3.64e-8 }; let(:s4_k) { 2.00 }; let(:s4_uexp) { 7.3e-8 }

    # S5 CALIBRATION OF A TYPE N THERMOCOUPLE AT 1000°C 
    # All components with infinite degrees of freedom
    let(:s5_data) { [stub(ux: 1.00e-1, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 1.00e+0, c: 7.70e-2,  v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 2.90e-1, c: 7.70e-2,  v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 1.15e+0, c: 7.70e-2,  v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 5.80e-2, c: -4.07e-1, v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 1.50e-1, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 1.73e-1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                     stub(ux: 5.77e-1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R') ] }
    let(:s5_uy) { 6.41e-1 }; let(:s5_k) { 2.00 }; let(:s5_uexp) { 1.3 }

    # S6 CALIBRATION OF A POWER SENSOR AT A FREQUENCY OF 19 GHZ
    # U-shaped distributions
    let(:s6_data) { [stub(ux: 9.00e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 2.50e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 1.10e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 2.00e-2, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 1.70e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 3.00e-4, c: -1.00e+0, v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 3.00e-4, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                     stub(ux: 2.00e-3, c: -1.00e+0, v: Float::INFINITY, dist: 'R'),
                     stub(ux: 2.00e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'N') ] }
    let(:s6_uy) { 2.24e-2 }; let(:s6_k) { 2.00 }; let(:s6_uexp) { 4.5e-2 }

    # S7-12 CALIBRATION OF A COAXIAL STEP ATTENUATOR AT A SETTING OF 30 DB (INCREMENTAL LOSS)
    # units in deciBel
    let(:s7_data) { [stub(ux: 9.00e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 2.50e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'), 
                     stub(ux: 1.10e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 2.00e-2, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 1.70e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 3.00e-4, c: -1.00e+0, v: Float::INFINITY, dist: 'U'), 
                     stub(ux: 3.00e-4, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                     stub(ux: 1.90e-3, c: -1.00e+0, v: Float::INFINITY, dist: 'R'),
                     stub(ux: 2.00e-3, c: 1.00e+0,  v: Float::INFINITY, dist: 'N') ] }
    let(:s7_uy) { 2.24e-2 }; let(:s7_k) { 2.00 }; let(:s7_uexp) { 4.5e-2 }

    # S9 CALIBRATION OF A HAND-HELD DIGITAL MULTIMETER AT 100 V DC
    # Dominant rectangular component
    # k = 1.65
    let(:s9_data) { [stub(ux: 1.00e-3, c: -1.00e+0, v: Float::INFINITY, dist: 'N'), 
                     stub(ux: 2.90e-2, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                     stub(ux: 6.40e-3, c: -1.00e+0, v: Float::INFINITY, dist: 'R') ] }
    let(:s9_uy) { 3.00e-2 }; let(:s9_k) { 1.65 }; let(:s9_uexp) { 5.0e-2 }

    # S10 CALIBRATION OF A VERNIER CALLIPER
    # Two dominant rectangular components, resulting in dominant trapezoidal
    # k = 1.83
    let(:s10_data) { [stub(ux: 4.60e-1, c: -1.00e+0, v: Float::INFINITY, dist: 'R'), 
                      stub(ux: 1.15e+0, c: 1.70e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 1.50e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 2.90e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R') ] }
    let(:s10_uy) { 3.30e+1 }; let(:s10_k) { 1.83 }; let(:s10_uexp) { 6.0e+1 }

    # S11 CALIBRATION OF A TEMPERATURE BLOCK CALIBRATOR AT A TEMPERATURE OF 180°C
    # Two dominant rectangular components, resulting in dominant trapezoidal
    # k = 1.81
    let(:s11_data) { [stub(ux: 1.50e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'), 
                      stub(ux: 1.00e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'N'),
                      stub(ux: 2.30e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 2.90e+1, c: -1.00e+0, v: Float::INFINITY, dist: 'R'),
                      stub(ux: 5.80e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 1.44e+2, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 2.90e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R'),
                      stub(ux: 1.70e+1, c: 1.00e+0,  v: Float::INFINITY, dist: 'R') ] }
    let(:s11_uy) { 1.64e+2 }; let(:s11_k) { 1.81 }; let(:s11_uexp) { 3.0e+2 }

    # S12.14 CALIBRATION OF A HOUSEHOLD WATER METER
    # Normality of uy not verified. k calculated through Welch-Satterthwaite and Inverse t-student distribution
    let(:s12_data) { [stub(ux: 6.00e-4, c: 1, v: 2,               dist: 'N'), 
                      stub(ux: 6.80e-4, c: 1, v: Float::INFINITY, dist: 'N') ] }
    let(:s12_uy) { 9.10e-4 }; let(:s12_k) { 2.28 }; let(:s12_uexp) { 2.0e-3 }


    # TEST EXAMPLE RESULTS
    [:s2, :s3, :s4, :s5, :s6, :s7, :s9, :s10, :s11, :s12].each do |e|
      it "should comply with example #{e.to_s}" do
        data = eval("#{e}_data")
        uy, k, uexp = eval("#{e}_uy"), eval("#{e}_k"), eval("#{e}_uexp")
        MeasurementManager.uy(data).should   be_within(0.01*uy).of(uy)
        MeasurementManager.k(data).should    be_within(0.01*k).of(k)
        MeasurementManager.uexp(data).should be_within(0.05*uexp).of(uexp)
      end
    end
  end
end
