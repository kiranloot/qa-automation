module Shipping
  module ZoneSkipping
    def self.mapping
      @@mapping ||= Hash[*(%w(CT ALPA
                              DC ALPA
                              DE ALPA
                              MA ALPA
                              MD ALPA
                              ME ALPA
                              NH ALPA
                              NJ ALPA
                              NY ALPA
                              PA ALPA
                              RI ALPA
                              VA ALPA
                              VT ALPA
                              AL ATGA
                              FL ATGA
                              GA ATGA
                              NC ATGA
                              SC ATGA
                              TN ATGA
                              AR DLTX
                              KS DLTX
                              LA DLTX
                              MO DLTX
                              MS DLTX
                              NE DLTX
                              OK DLTX
                              TX DLTX
                              IL GCOH
                              IN GCOH
                              KY GCOH
                              MI GCOH
                              OH GCOH
                              WI GCOH
                              WV GCOH
                              AZ LACA
                              CA LACA
                              CO LACA
                              IA LACA
                              ID LACA
                              MN LACA
                              MT LACA
                              ND LACA
                              NM LACA
                              NV LACA
                              OR LACA
                              SD LACA
                              UT LACA
                              WA LACA
                              WY LACA))]
    end

    def self.for_address(address)
      return nil unless address && address.country == 'US'

      mapping[address.state]
    end
  end
end
