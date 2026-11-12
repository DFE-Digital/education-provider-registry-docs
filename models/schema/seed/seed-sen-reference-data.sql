-- Stable target IDs. Source text codes preserve their leading zeroes.
INSERT INTO establishment.sen (sen_id, code, name) VALUES
    (1, '01', 'VI - Visual Impairment'),
    (2, '02', 'HI - Hearing Impairment'),
    (3, '03', 'SLCN - Speech, language and Communication'),
    (4, '04', 'ASD - Autistic Spectrum Disorder'),
    (5, '05', 'SEMH - Social, Emotional and Mental Health'),
    (6, '06', 'MSI - Multi-Sensory Impairment'),
    (7, '07', 'PD - Physical Disability'),
    (8, '08', 'MLD - Moderate Learning Difficulty'),
    (9, '09', 'SLD - Severe Learning Difficulty'),
    (10, '10', 'PMLD - Profound and Multiple Learning Difficulty'),
    (11, '11', 'SpLD - Specific Learning Difficulty'),
    (12, '12', 'OTH - Other Difficulty/Disability')
ON CONFLICT (sen_id) DO NOTHING;
